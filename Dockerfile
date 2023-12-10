FROM debian:latest

###############################
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    wget ca-certificates cpanminus libyaml-tiny-perl libfile-homedir-perl

RUN wget https://raw.githubusercontent.com/cmhughes/latexindent.pl/main/helper-scripts/latexindent-module-installer.pl && echo "Y"|perl latexindent-module-installer.pl && rm latexindent-module-installer.pl

###############################
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    python3 python3-pip python3-venv

###############################
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    screen curl git unzip vim openssh-server gnupg gnupg2

RUN mkdir /run/sshd

###############################
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    build-essential gfortran automake cmake pkg-config help2man doxygen

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libgsl0-dev libsqlite3-dev libfreetype6-dev libfontconfig1-dev libssl-dev libboost-all-dev libopenblas-dev libhdf5-dev

###############################
RUN useradd -m -d /home/vscode -s /bin/bash vscode

USER vscode

RUN echo -e "defscrollback 10000\ntermcapinfo xterm* ti@:te@" > ~/.screenrc

###############################
RUN echo 'export PATH="$PATH:/usr/local/texlive/bin/aarch64-linux"' >> ~/.bashrc
RUN echo 'export MANPATH="$MANPATH:/usr/local/texlive/texmf-dist/doc/man"' >> ~/.bashrc
RUN echo 'export INFOPATH="$INFOPATH:/usr/local/texlive/texmf-dist/doc/info"' >> ~/.bashrc

###############################
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN /home/vscode/.cargo/bin/rustup component add rust-analysis rust-src rls

###############################
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

RUN export NVM_DIR="$HOME/.nvm" && \. "$NVM_DIR/nvm.sh" && \. "$NVM_DIR/bash_completion" && nvm install node

###############################

USER root

CMD ["/usr/sbin/sshd", "-D"]