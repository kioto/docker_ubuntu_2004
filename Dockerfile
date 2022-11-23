FROM ubuntu:20.04

ENV USER=kioto
ENV PASSWORD=password
ENV GIT_EMAIL=kioto.hirahara@gmail.com
ENV GIT_NAME="Kioto Hirahara"
ENV HOME=/home/${USER}
ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja

USER root

# update packages
RUN set -x && \
    apt update && \
    apt upgrade -y

# install command
RUN set -x && \
    apt install -y tzdata

RUN set -x && \
    apt install -y wget sudo git vim sudo curl libssl-dev tmux gcc make \
    build-essential automake autoconf cmake libmbedtls-dev squashfs-tools \
    ssh-askpass pkg-config apt-transport-https ca-certificates gnupg \
    lsb-release libwxgtk3.0-gtk3-dev libssl-dev libncurses5-dev python3

# share
RUN set -x && \
    mkdir -p /shar

# user
RUN set -x && \
    useradd -s /bin/bash -m ${USER} && \
    gpasswd -a ${USER} sudo && \
    echo "${USER}:${PASSWORD}" | chpasswd

USER ${USER}
WORKDIR ${HOME}

# git
RUN set -x && \
    git config --global user.email ${GIT_EMAIL} && \
    git config --global user.name "${GIT_NAME}" && \
    git config --global log.decorate auto && \
    git config --global credential.helper store

# tmux
RUN set -x && \
    echo "set -g prefix C-t\nunbind C-b\n" > /${HOME}/.tmux.conf

# pyenv
RUN set -x && \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    cd ~/.pyenv && src/configure && make -C src && cd ~  && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

RUN /bin/bash -c 'source ${HOME}/.bashrc ; \
    ${HOME}/.pyenv/bin/pyenv install ${PYTHON_VER} ; \
    ${HOME}/.pyenv/bin/pyenv global ${PYTHON_VER}'

# asdf
RUN git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch v0.8.0  && \
    echo '. ${HOME}/.asdf/asdf.sh' >> ${HOME}/.bashrc && \
    echo '. ${HOME}/.asdf/asdf.sh' >> ${HOME}/.profile

ENV PATH="${PATH}:${HOME}/.asdf/shims:${HOME}/.asdf/bin"

# Install Erlang
RUN asdf plugin-add erlang
RUN asdf install erlang 24.0.6
RUN asdf global erlang 24.0.6

# Install Elixir
RUN asdf plugin-add elixir
RUN asdf install elixir 1.12.2-otp-24
RUN asdf global elixir 1.12.2-otp-24
