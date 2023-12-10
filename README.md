# Development environment for VSCode Remote SSH
## Description
LaTeX, Python3, C++, Fortran, Rust for VSCode Remote SSH

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
```