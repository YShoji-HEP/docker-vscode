# Development environment for VSCode Remote SSH
## Description
LaTeX, Python3, C++, Fortran, Rust for VSCode Remote SSH

(Only for AArch64)

## Packages

### LaTeX
* texlive (external volume)
* latexindent

### Python
* python3
* pip3
* venv

### C++ & Fortran
* build-essential
* gfortran

### Rust
* stable

### Node.js
* node via nvm

### Library
* gsl
* boost-all
* openblas
* hdf5
* ssl

## Install TeX Live
Mount an external volume to `/usr/local/texlive` and run the following to install TeX Live.
```
#!/bin/bash
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar zxf install-tl-unx.tar.gz
rm install-tl-unx.tar.gz
cd install-tl-*
perl ./install-tl --no-interaction --portable
cd ..
rm -r install-tl-*
```

## Docker
Optionally mount `\home\vscode\.ssh`,  `\home\vscode\.gitconfig`, `\home\vscode\.vscode-server`,   `\etc\ssh`.
```
version: "3"
services:
  vscode:
    ports:
      - "2222:22"
    container_name: vscode
    restart: always
    hostname: vscode
    image: yshojihep/vscode:latest
    volumes:
      - /path/to/vol:/usr/local/texlive
```

## Kubernetes
```
---
apiVersion: v1
kind: Pod
metadata:
  name: vscode
spec:
  hostname: vscode
  containers:
    - name: app
      securityContext:
        capabilities:
          add:
            - SYS_CHROOT
            - AUDIT_WRITE
      image: yshojihep/vscode:latest
      ports:
        - containerPort: 22
      volumeMounts:
        - name: texlive
          mountPath: /usr/local/texlive
```