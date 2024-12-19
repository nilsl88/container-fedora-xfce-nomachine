# Container alternative to Virtual Machines for Transient Environments That Require GUI's

A Fedora based Container/Docker image with Xfce and NoMachine which allows for local Virtual Machine equivalent graphical performance (as opposed to X11, VNC and RDP), accessing the desktop environment.

### Inspiration from

[docker-fedora-xfce-nomachine](https://github.com/cmanique/docker-fedora-xfce-nomachine) Also [Docker as an Alternative to Virtual Machines for Transient Environments That Require a GUI](https://dev.to/cmanique/docker-as-an-alternative-to-virtual-machines-for-transient-environments-that-require-a-gui-24la)

## How use

### a) Build the image from this repository

```
$ git clone https://github.com/cmanique/docker-fedora-xfce-nomachine.git
$ cd fedora-xfce-nomachine
$ alias docker=podman
$ docker build -t fedora-xfce-nomachine .
```   

### b) Directly from Docker Hub

```
$ alias docker=podman
$ docker pull docker.io/lundberg88/fedora-xfce-nomachine<tag>
```

### Start a container

```
$ alias docker=podman
$ docker run --privileged -d -p 4000:4000 -p -p 4000:4000/udp -name fedora-xfce-nomachine docker.io/lundberg88/fedora-xfce-nomachine:<tag>
```

### Stop the container

```
$ alias docker=podman
$ docker stop fedora-xfce-nomachine
# Or stop and remove 
$ docker rm -f fedora-xfce-nomachine
```
