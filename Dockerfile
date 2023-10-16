FROM mcr.microsoft.com/dotnet/sdk:6.0.415
USER root
ENV HOME /root
WORKDIR /code
SHELL ["/bin/bash", "--login", "-c"]

##
# Update dependencies
##
RUN apt-get -y update && apt-get -y upgrade

##
# Install general dependencies
##
RUN apt-get install -y \
    ca-certificates \
    curl \
    git \
    gnupg \
    nano \
    sudo \
    unzip \
    && echo;

##
# General dotnet environment variables
##
ENV DOTNET_ROLL_FORWARD=LatestMajor
ENV DOTNET_NOLOGO=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

##
# Prepare dotnet tools
##
RUN mkdir -p ${HOME}/.dotnet/tools
ENV PATH=$PATH:${HOME}/.dotnet/tools

##
# Setup nvm and node
##
RUN NVM_LATEST_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+') && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_LATEST_VERSION/install.sh | bash
RUN nvm install --lts && \
    nvm use --lts

##
# Setup docker
# Note: dotnet/sdk images are based on Debian
# See: https://docs.docker.com/engine/install/debian/
##
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get -y update && \
    apt-get install -y \
        containerd.io \
        docker-buildx-plugin \
        docker-ce \
        docker-ce-cli \
        docker-compose-plugin \
        && echo;

##
# Setup nano
##
RUN curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

##
# Modify prompt (colours)
##
RUN echo 'export PS1="\e[1;35m${debian_chroot:+($debian_chroot)}\u@\h:\[\033[01;34m\]\w\[\033[00m\] \$ "' >> $HOME/.bashrc
