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
    openjdk-17-jdk \
    openjdk-17-jre \
    graphviz

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

RUN chmod 777 /tmp

RUN wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz && \
tar xzf apache-maven-3.8.8-bin.tar.gz -C /opt && \
ln -s /opt/apache-maven-3.8.8 /opt/maven

# ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=${M2_HOME}/bin:${PATH}

RUN pip3 install pydot

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Set up environment variables
ENV EDHOC_FUZZER="/home/ubuntu/edhoc-fuzzer"
ENV SCRIPTS="/home/ubuntu/scripts"
ENV AUTOMATA="/home/ubuntu/automata"
ENV PATH="${PATH}:${SCRIPTS}"

# Set up edhoc-fuzzer
COPY --chown=ubuntu:ubuntu edhoc-fuzzer.patch ${WORKDIR}/edhoc-fuzzer.patch
RUN cd ${WORKDIR} && \
    git clone https://github.com/protocol-fuzzing/edhoc-fuzzer && \
    ls
RUN cd ${EDHOC_FUZZER} && \
    patch -p1 < ${WORKDIR}/edhoc-fuzzer.patch && \
    bash ./scripts/setup_fuzzer.sh -l

# Set up the SUTs
RUN cd ${EDHOC_FUZZER} && ./scripts/setup_sul.sh uoscore-uedhoc

COPY --chown=ubuntu:ubuntu args ${EDHOC_FUZZER}/args
COPY --chown=ubuntu:ubuntu examples ${EDHOC_FUZZER}/examples

# Set up the scripts
COPY --chown=ubuntu:ubuntu scripts ${SCRIPTS}

RUN mkdir ${AUTOMATA}