FROM ubuntu:20.04


ENV PYTHON_PKG=python3.8
ENV USER=kioto
ENV PASSWORD=password


# update packages
RUN set -x && \
        apt update && \
        apt upgrade -y

# install command
RUN set -x && \
        apt install -y wget sudo git vim sudo curl libssl-dev tmux gcc make

# symbolic link python
RUN set -x && \
        apt install -y ${PYTHON_PKG} && \
        ln -s /usr/bin/${PYTHON_PKG} /usr/bin/python && \
        ln -s /usr/bin/${PYTHON_PKG} /usr/bin/python3

# share
RUN set -x && \
        mkdir -p /shar

# user
RUN set -x && \
	useradd -s /bin/bash -m ${USER} && \
	gpasswd -a ${USER} sudo && \
	echo "${USER}:${PASSWORD}" | chpasswd

ENV LANG=ja_JP.UTF-8
USER ${USER}
WORKDIR ${HOME}

RUN set -x && \
	git config --global user.email "kioto.hirahara@gmail.com" && \
	git config --global user.name "Kioto Hirahara" && \
	git config --global log.decorate auto && \
	git config --global credential.helper store

USER root
EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]
