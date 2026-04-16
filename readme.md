# Container Alternative to Virtual Machines for Transient GUI Environments

A Fedora-based container image with Xfce and NoMachine that provides local virtual-machine-like graphical performance (as opposed to X11, VNC, and RDP) for accessing a full desktop environment.

## Inspiration

- [docker-fedora-xfce-nomachine](https://github.com/cmanique/docker-fedora-xfce-nomachine)
- [Docker as an Alternative to Virtual Machines for Transient Environments That Require a GUI](https://dev.to/cmanique/docker-as-an-alternative-to-virtual-machines-for-transient-environments-that-require-a-gui-24la)

## Usage

### 1) 🛠️ Build the image from this repository

```bash
git clone https://github.com/nilsl88/container-fedora-xfce-nomachine.git
cd container-fedora-xfce-nomachine
podman build -t fedora-xfce-nomachine .
```

If you want to build for both CPU architectures (`amd64` + `arm64`) and publish a multi-arch manifest:

```bash
export IMAGE=docker.io/<user>/<repo>:<tag>
podman build \
  --platform linux/amd64,linux/arm64 \
  --manifest $IMAGE \
  .
podman manifest push --all $IMAGE docker://$IMAGE
```

### 2) 📥 Pull directly from Docker Hub

```bash
podman pull docker.io/lundberg88/fedora-xfce-nomachine:<tag>
```

### 3) 🚀 Start a container

```bash
podman run --privileged -d -p 4000:4000 -p 4000:4000/udp --name fedora-xfce-nomachine docker.io/lundberg88/fedora-xfce-nomachine:<tag>
```

### 4) 🛑 Stop and remove the container

```bash
podman stop fedora-xfce-nomachine
# Optional: stop and remove
podman rm -f fedora-xfce-nomachine
```

## Access

After the container starts, connect with NoMachine to your host on port `4000`.
