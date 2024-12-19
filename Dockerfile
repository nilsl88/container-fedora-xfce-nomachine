FROM fedora:41

# get a slightly lighter version of xfce that actually works and some common tools for development and troubleshooting
# certainly can be made skinnier, in due time
RUN echo 'max_parallel_downloads=20' | tee -a /etc/dnf/dnf.conf && \
    dnf update -y \
    && dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && dnf install -y @xfce-desktop-environment \
    && dnf install -y polkit curl wget tcpdump vim-enhanced nano net-tools procps-ng firefox bash-completion fuse fuse-sshfs fuse-common fuse-libs htop nmon virt-manager axel git \
    && dnf install -y pulseaudio --allowerasing \
    && dnf install -y pulseaudio-utils \
    && dnf clean all

# workaround the fact that not all distros generate a machine-id when running inside container
# prevent dbus failures for lack of /var/run/dbus
RUN mkdir -p /var/lib/dbus && dbus-uuidgen > /var/lib/dbus/machine-id && mkdir -p /var/run/dbus

# set system keymap
#RUN localectl set-keymap dk

# Disable SELinux
RUN sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

# Install NoMachine
ARG NOMACHINE_AMD64_RPM="nomachine_8.14.2_1_x86_64.rpm"
ARG NOMACHINE_ARM64_RPM="nomachine_8.14.2_1_aarch64.rpm"
ARG NOMACHINE_URL_AMD64="https://download.nomachine.com/download/8.14/Linux/${NOMACHINE_AMD64_RPM}"
ARG NOMACHINE_URL_ARM64="https://download.nomachine.com/download/8.14/Arm/${NOMACHINE_ARM64_RPM}"

RUN echo "$NOMACHINE_AMD64_RPM" && \
    echo "$NOMACHINE_URL_AMD64" && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        NOMACHINE_VERSION=$(echo "$NOMACHINE_AMD64_RPM" | sed -n 's/nomachine_\([0-9]*\.[0-9]*\)\..*/\1/p'); \
        curl -fSL "https://download.nomachine.com/download/$NOMACHINE_VERSION/Linux/${NOMACHINE_AMD64_RPM}" -o nomachine.rpm; \
    elif [ "$ARCH" = "aarch64" ]; then \
        NOMACHINE_VERSION=$(echo "$NOMACHINE_ARM64_RPM" | sed -n 's/nomachine_\([0-9]*\.[0-9]*\)\..*/\1/p'); \
        curl -fSL "https://download.nomachine.com/download/$NOMACHINE_VERSION/Arm/${NOMACHINE_ARM64_RPM}" -o nomachine.rpm; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    rpm -i nomachine.rpm && \
    rm -rf nomachine.rpm && \
    /usr/NX/bin/nxserver --startup


# add a user to access our desktop env
RUN groupadd -r nomachine -g 10000 && \
    useradd nomachine -u 10000 -g nomachine -d /home/nomachine -m -s /bin/bash && \
    echo 'nomachine:nomachine' | chpasswd && \
    usermod -a -G libvirt nomachine

# add user to suduoers
RUN echo "nomachine ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/nomachine" && \
    chmod 440 "/etc/sudoers.d/nomachine"

# make systemctl not go into graphical mode
RUN ln -s /lib/systemd/system/systemd-logind.service /etc/systemd/system/multi-user.target.wants/systemd-logind.service
RUN systemctl set-default multi-user.target

COPY nxserver.service /usr/lib/systemd/system/nxserver.service
RUN ln -s /lib/systemd/system/nxserver.service /etc/systemd/system/multi-user.target.wants/nxserver.service

ENTRYPOINT ["/sbin/init"]
