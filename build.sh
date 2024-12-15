#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

curl https://copr.fedorainfracloud.org/coprs/kwizart/kernel-longterm-6.6/repo/fedora-41/kwizart-kernel-longterm-6.6-fedora-41.repo -o /etc/yum.repos.d/kernel-lts.repo
curl https://copr.fedorainfracloud.org/coprs/ganto/lxc4/repo/fedora-41/ganto-lxc4-fedora-41.repo -o /etc/yum.repos.d/incus.repo

rpm-ostree cliwrap install-to-root /
rpm-ostree override remove kernel kernel-{core,modules,modules-core} \
    --install kernel-longterm --install kernel-longterm-core \
    --install kernel-longterm-modules --install kernel-longterm-modules-extra && \
    ostree container commit

# this installs a package from fedora repos
# rpm-ostree install screen
rpm-ostree install incus

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

# systemctl enable podman.socket
systemctl enable incus.service
