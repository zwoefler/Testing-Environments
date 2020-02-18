# Testing out Kubespray
This is a kubespray testing repository with a Vagrantfile to start asap.
4 machines (Ubuntu) are created, connected to a private network.

# Works on
Ubuntu 18.04 LTS (bionic)

## ToDos
1. Initialize the 4 machines, 3 nodes, 1 ansible master
*. Install Ansible on the Ansible-master
*. Generate SSH Key-Pair on Ansible host
*. ssh-copy-id to remaining three nodes