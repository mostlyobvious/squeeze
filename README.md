Squeeze
=======

Run commands in isolated, one-time LXC containers.


Prerequisites
-------------

- Linux operating system
- kernel with LXC and AUFS support
- lxc tools

On Ubuntu Precise vanilla distro this is satisfied by just:

    sudo apt-get install lxc
    sudo modprobe aufs


Example usage
-------------

Create container template first:

    sudo lxc-create -n squeeze-template-ubuntu -t ubuntu

Run `ifconfig` concurrently in 4 containers:

    squeeze -n 4 -t squeeze-template-ubuntu -- ifconfig


Trying development version
--------------------------

You can find Vagrantfile with url to Ubuntu machine I use. To get it running:

    vagrant up
    vagrant ssh

Run binary as `RUBYLUB=/vagrant/squeeze /vagrant/squeeze/bin/squeeze`. Remember to satisfy prerequisites.

