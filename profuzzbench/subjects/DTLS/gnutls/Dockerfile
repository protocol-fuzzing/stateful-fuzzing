FROM ubuntu:20.04

# Install common dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get -y install sudo \ 
    apt-utils \
    build-essential \
    openssl \
    clang \
    graphviz-dev \
    git \
    autoconf \
    libgnutls28-dev \
    libssl-dev \
    llvm \
    python3-pip \
    nano \
    net-tools \
    vim \
    gdb \
    netcat \
    strace \
    wget \
		libcap-dev \
		pkg-config \
		bsdmainutils \
		automake \
		libtool \
		tshark \
		dash git-core gettext autopoint nettle-dev libp11-kit-dev libtspi-dev libunistring-dev libtasn1-bin libtasn1-6-dev libidn2-0-dev gawk gperf libtss2-dev libunbound-dev dns-root-data bison gtk-doc-tools libev-dev

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

RUN chmod 777 /tmp

RUN pip3 install gcovr==4.2

RUN mkdir /home/ubuntu/modules && \
		cd /home/ubuntu/modules && \
		wget https://ftp.gnu.org/gnu/nettle/nettle-3.6.tar.gz && \
		tar -xvf nettle-3.6.tar.gz && \
		cd nettle-3.6 && \
		./configure && \
		make install
RUN chown -R ubuntu /home/ubuntu/modules

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

COPY --chown=ubuntu:ubuntu aflnet.patch ${WORKDIR}/aflnet.patch

# Set up fuzzers
RUN git clone https://github.com/profuzzbench/aflnet.git && \
    cd aflnet && \
		git checkout 0f51f9e && \
    patch -p1 < $WORKDIR/aflnet.patch && \
    make clean all $MAKE_OPT && \
    cd llvm_mode && make $MAKE_OPT

RUN git clone https://github.com/profuzzbench/aflnwe.git && \
    cd aflnwe && \
    make clean all $MAKE_OPT && \
    cd llvm_mode && make $MAKE_OPT

# Set up environment variables for AFLNet
ENV WORKDIR="/home/ubuntu/experiments"
ENV AFLNET="/home/ubuntu/aflnet"
ENV PATH="${PATH}:${AFLNET}:/home/ubuntu/.local/bin:${WORKDIR}"
ENV AFL_PATH="${AFLNET}"
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1


RUN mkdir $WORKDIR

COPY --chown=ubuntu:ubuntu determ.patch ${WORKDIR}/determ.patch
RUN mv /home/ubuntu/modules ${WORKDIR}/

# Set up environment variables for ASAN
env ASAN_OPTIONS='abort_on_error=1:symbolize=0:detect_leaks=0:detect_stack_use_after_return=1:detect_container_overflow=0:poison_array_cookie=0:malloc_fill_byte=0:max_malloc_fill_size=16777216'

# Download and compile GNUTLS for fuzzing
RUN cd $WORKDIR && \
    git clone https://gitlab.com/gnutls/gnutls.git gnutls && \
    cd gnutls && \
		git checkout c4023afd && \
    patch -p1 < $WORKDIR/determ.patch && \
		./bootstrap && \
		AFL_USE_ASAN=1 CC=afl-clang-fast PKG_CONFIG_PATH="$WORKDIR/modules/nettle-3.6:$PKG_CONFIG_PATH" ./configure --enable-static --with-included-libtasn1 --with-included-unistring --without-p11-kit --disable-doc --enable-fuzzer-target && \
    AFL_USE_ASAN=1 CC=afl-clang-fast make $MAKE_OPT

## Download and compile GNUTLS for coverage analysis
RUN cd $WORKDIR && \
    git clone https://gitlab.com/gnutls/gnutls.git gnutls-gcov && \
    cd gnutls-gcov && \
		git checkout c4023afd && \
    patch -p1 < $WORKDIR/determ.patch && \
		./bootstrap && \
		CFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage" PKG_CONFIG_PATH="$WORKDIR/modules/nettle-3.6:$PKG_CONFIG_PATH" ./configure --enable-static --with-included-libtasn1 --with-included-unistring --without-p11-kit --disable-doc --enable-fuzzer-target && \
    CFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage" make $MAKE_OPT

COPY --chown=ubuntu:ubuntu in-dtls ${WORKDIR}/in-dtls
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
COPY --chown=ubuntu:ubuntu keystore ${WORKDIR}/keystore
