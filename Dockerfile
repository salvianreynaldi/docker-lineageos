FROM ubuntu:16.04

ENV \
# ccache specifics
    CCACHE_SIZE=50G \
    CCACHE_DIR=/home/build/ccache \
    USE_CCACHE=1 \
    CCACHE_COMPRESS=1 \
    USER=root \
# Extra include PATH, it may not include /usr/local/(s)bin on some systems
    PATH=$PATH:/usr/local/bin/

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt update \
 && apt dist-upgrade -y \
 && apt install -y \
# Install build dependencies (source: https://wiki.lineageos.org/devices/sagit/build)
    bc \
    bison \
    build-essential \
    ccache \
    curl \
    flex \
    g++-multilib \
    gcc-multilib \
    git \
    gnupg \
    gperf \
    imagemagick \
    lib32ncurses5-dev \
    lib32readline-dev \
    lib32z1-dev \
    libesd0-dev \
    liblz4-tool \
    libncurses5-dev \
    libsdl1.2-dev \
    libssl-dev \
    libwxgtk3.0-dev \
    libxml2 \
    libxml2-utils \
    lzop \
    pngcrush \
    rsync \
    schedtool \
    squashfs-tools \
    xsltproc \
    zip \
    zlib1g-dev \
    openjdk-8-jdk-headless \
# Install additional packages which are useful for building Android
    android-tools-adb \
    android-tools-fastboot \
    bash-completion \
    bsdmainutils \
    file \
    nano \
    python \
    tmux \
    sudo \
    wget \
 && rm -rf /var/lib/apt/lists/*

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
 && chmod a+x /usr/local/bin/repo

# Add sudo permission
RUN echo "build ALL=NOPASSWD: ALL" > /etc/sudoers.d/build

RUN ccache -M ${CCACHE_SIZE}

# Fix ownership
RUN chown -R root:root /home/build

VOLUME /home/build/android
VOLUME /home/build/ccache

USER root
WORKDIR /home/build/android

ENTRYPOINT /bin/bash
CMD ["-eo", "pipefail"]
