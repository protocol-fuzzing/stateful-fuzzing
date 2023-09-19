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
    tshark

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

RUN chmod 777 /tmp

RUN pip3 install gcovr==4.2

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

RUN git clone https://github.com/remiparrot/aflnet aflml && \
    cd aflml && \
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

COPY --chown=ubuntu:ubuntu fuzzing.patch ${WORKDIR}/fuzzing.patch
# COPY --chown=ubuntu:ubuntu gcov.patch ${WORKDIR}/gcov.patch

# Set up environment variables for ASAN
# env ASAN_OPTIONS='abort_on_error=1:symbolize=0:detect_leaks=0:detect_stack_use_after_return=1:detect_container_overflow=0:poison_array_cookie=0:malloc_fill_byte=0:max_malloc_fill_size=16777216'

# Download and compile uOSCORE / uEDHOC for fuzzing
RUN cd $WORKDIR && \
    git clone --recurse-submodules https://github.com/eriptic/uoscore-uedhoc.git uoscore-uedhoc && \
    cd uoscore-uedhoc && \
    git checkout 5fe2cb613bd7e4590bd1b00c2adf181ac0229379 && \
    patch -p1 < $WORKDIR/fuzzing.patch && \
    make clean && \
    # AFL_USE_ASAN=1 
    CXX=afl-clang-fast++ CC=afl-clang-fast make -C samples/linux_edhoc_oscore/responder_server $MAKE_OPT

# Download and compile uOSCORE / uEDHOC for coverage analysis
RUN cd $WORKDIR && \
    git clone --recurse-submodules https://github.com/eriptic/uoscore-uedhoc.git uoscore-uedhoc-gcov && \
    cd uoscore-uedhoc-gcov && \
    git checkout 5fe2cb613bd7e4590bd1b00c2adf181ac0229379 && \
    # patch -p1 < $WORKDIR/gcov.patch && \
    make clean && \
    CFLAGS="-fprofile-arcs -ftest-coverage" CXXFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage" make -C samples/linux_edhoc_oscore/responder_server $MAKE_OPT

COPY --chown=ubuntu:ubuntu in-edhoc ${WORKDIR}/in-edhoc
COPY --chown=ubuntu:ubuntu in-edhoc-aflml ${WORKDIR}/in-edhoc-aflml
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
COPY --chown=ubuntu:ubuntu run-aflml.sh ${WORKDIR}/run-aflml
