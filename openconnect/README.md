# OpenConnect VM 
Creates a VM with OpenConnect for SSH Forwarding

## Goal
Have a VM to use as an VPN-Tunnel and Agent Forwarding for SSH connection to production/Testing-whatever machines

## Prerequisites
1. Install Vagrant: `sudo apt install vagarant`
2. Install VirtualBox: `sudo apt install virtualbox`


## Run this repository
Simply run:
`vagrant up`

A VM with Openconnect installed will be created and SSH-Agent Forwarding enabled.
- Connect to the VM via: `vagrant ssh`
- Start openconnect with the command provided by your VPN-Authority. SOmething like `sudo openconnect --juniper URL`
- From your Hostmachine, create a new terminal session. `vagrant ssh` into the VM and connect via SSH to your desired Machine


### ToDo


