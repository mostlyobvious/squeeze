Squeeze
=======

Run commands in isolated, one-time LXC containers.


Prerequisites
-------------

- Linux with LXC and AUFS support in kernel
- libvirt, avahi and debootstrap userspace tools


On Ubuntu Precise vanilla distro this is satisfied by just:

    sudo apt-get install libvirt-bin debootstrap avahi-daemon
    sudo modprobe aufs


Example usage
-------------

Create container template first usign helper script:

    wget -O - https://raw.github.com/gist/3155902/efb7e57e13b475ddeb363525fb96ca9cac81a277/bootstrap.sh | sh

Run `hostname` concurrently in 4 containers:

    squeeze -t template -k template.key -n 4 -- hostname


Trying development version
--------------------------

You can find Vagrantfile with url to Ubuntu machine I use. To get it running:

    vagrant up
    vagrant ssh

Run binary as `RUBYLUB=~/squeeze/lib ~/squeeze/bin/squeeze`. Remember to satisfy prerequisites.


Performance
-----------

On Ubuntu running under Vagrant and Macbook Air hardware:

- container start takes about 3s
- container stop takes about 2s

LXC performance hit compared to native system is about 1-3% according to documentation.

