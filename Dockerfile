FROM debian:trixie

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
    screen curl git unzip vim openssh-server gnupg gnupg2 rsync locales

RUN locale-gen en_US.UTF-8

# RUN mkdir /run/sshd

###############################
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    build-essential gfortran automake cmake pkg-config help2man doxygen

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libgsl0-dev libsqlite3-dev libfreetype6-dev libfontconfig1-dev libssl-dev libboost-all-dev libopenblas-dev libhdf5-dev \
    liblapacke-dev libsuitesparse-dev

###############################
RUN useradd -m -d /home/vscode -s /bin/bash vscode

RUN curl -skL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-arm64" --output vscode_cli.tar.gz \
    && tar -xf vscode_cli.tar.gz -C /usr/bin \
    && rm vscode_cli.tar.gz

USER vscode

RUN echo -e "defscrollback 10000\ntermcapinfo xterm* ti@:te@" > ~/.screenrc

###############################
RUN echo 'TEXLIVE_ARCH=`ls /usr/local/texlive/bin/`' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/usr/local/texlive/bin/$TEXLIVE_ARCH"' >> ~/.bashrc
RUN echo 'export MANPATH="$MANPATH:/usr/local/texlive/texmf-dist/doc/man"' >> ~/.bashrc
RUN echo 'export INFOPATH="$INFOPATH:/usr/local/texlive/texmf-dist/doc/info"' >> ~/.bashrc

###############################
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN /home/vscode/.cargo/bin/rustup component add rust-analyzer rust-src miri

###############################
#RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

#RUN export NVM_DIR="$HOME/.nvm" && \. "$NVM_DIR/nvm.sh" && \. "$NVM_DIR/bash_completion" && nvm install node

###############################

USER root

RUN echo '#!/bin/bash\n/usr/sbin/sshd -D&\nif [[ -z "${VSCODE_TUNNEL}" ]]; then\n tail -f /dev/null\nelse\n su vscode -c "code tunnel --accept-server-license-terms"\nfi' > /entrypoint.sh

RUN chmod a+x /entrypoint.sh

CMD ["/entrypoint.sh"]
