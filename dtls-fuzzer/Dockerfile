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
		openjdk-8-jdk \
		maven \
		graphviz \
		autotools-dev \
		automake \
		libtool \
		bsdmainutils \
		tshark \
		dash git-core gettext autopoint nettle-dev libp11-kit-dev libtspi-dev libunistring-dev libtasn1-bin libtasn1-6-dev libidn2-0-dev gawk gperf libtss2-dev libunbound-dev dns-root-data bison gtk-doc-tools libev-dev

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

RUN chmod 777 /tmp

RUN update-java-alternatives --set java-1.8.0-openjdk-amd64

RUN pip3 install pydot

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

# Set up environment variables
ENV DTLS_FUZZER="/home/ubuntu/dtls-fuzzer"
ENV SCRIPTS="/home/ubuntu/scripts"
ENV AUTOMATA="/home/ubuntu/automata"
ENV PATH="${PATH}:${SCRIPTS}"

# Set up DTLS-fuzzer
COPY --chown=ubuntu:ubuntu dtls-fuzzer.patch ${WORKDIR}/dtls-fuzzer.patch
RUN wget https://github.com/assist-project/dtls-fuzzer/archive/refs/tags/usenix20-artifact.tar.gz && \
    tar -xvf usenix20-artifact.tar.gz && \
		mv dtls-fuzzer-usenix20-artifact ${DTLS_FUZZER} && \
		cd ${DTLS_FUZZER} && \
    patch -p1 < ${WORKDIR}/dtls-fuzzer.patch && \
		bash prepare.sh && \
		mvn clean install

# Set up the SUTs
COPY --chown=ubuntu:ubuntu setup_sut.sh ${DTLS_FUZZER}/setup_sut.sh
COPY --chown=ubuntu:ubuntu patches ${DTLS_FUZZER}/experiments/patches
RUN cp -r /home/ubuntu/modules ${DTLS_FUZZER}/modules

RUN cd ${DTLS_FUZZER} && ./setup_sut.sh etinydtls
RUN cd ${DTLS_FUZZER} && ./setup_sut.sh openssl-1.1.1
RUN cd ${DTLS_FUZZER} && ./setup_sut.sh openssl-3.0
RUN cd ${DTLS_FUZZER} && ./setup_sut.sh wolfssl
RUN cd ${DTLS_FUZZER} && ./setup_sut.sh mbedtls
RUN cd ${DTLS_FUZZER} && ./setup_sut.sh etinydtls-5e14e49
RUN cd ${DTLS_FUZZER} && ./setup_sut.sh gnutls

COPY --chown=ubuntu:ubuntu args ${DTLS_FUZZER}/args
COPY --chown=ubuntu:ubuntu examples ${DTLS_FUZZER}/examples

# Set up the scripts
COPY --chown=ubuntu:ubuntu scripts ${SCRIPTS}

RUN mkdir ${AUTOMATA}
