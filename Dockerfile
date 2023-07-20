FROM mcr.microsoft.com/dotnet/sdk:6.0
USER root
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
    curl \
    git \
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
RUN mkdir -p $HOME/.dotnet/tools
ENV PATH=$PATH:$HOME/.dotnet/tools

##
# Setup nvm and node
##
RUN NVM_LATEST_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+') && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_LATEST_VERSION/install.sh | bash
RUN nvm install --lts && \
    nvm use --lts

##
# Modify prompt (colours)
##
ENV PS1="\e[1;35m${debian_chroot:+($debian_chroot)}\u@\h:\[\033[01;34m\]\w\[\033[00m\] \$ "
