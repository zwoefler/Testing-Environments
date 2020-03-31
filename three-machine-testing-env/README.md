# Local three machine testing environment
This repository consists of three virtual machines.

## Goal
Three VMs will come up. One of them is configured with SSH-Keys, mandatory packages and a cloned github repository.
The two other VMs can be used as Nodes of any kind, to experiment with any service.


## Prerequisites
1. Install Vagrant: `sudo apt install vagarant`
2. Install VirtualBox: `sudo apt install virtualbox`


## Run this repository
Simply run:
`vagrant up`

And three virtual machines will come up.
One AdminVM and two NodeVMs.


### ToDo
- Write the pllbook with proper roles
- Write the playbook with a variable file!