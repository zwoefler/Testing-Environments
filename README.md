# Testing-Environments
This repository contains different testing environemnts for all kinds of technologies

## The Goal
Test whatever technology you want, by just pressing a button, to create a testing environment, either locally, or without a lot of manual setup-steps, in your cloud-environment!

## Content
### Kubespray-test:
A configured Kubernetes Cluster containing three nodes, running as VMs on your local machine. An environment using virtual machines (with Vagrant), provisioned with Ansible to play around with [kubespray]("https://github.com/kubernetes-sigs/kubespray").




# How to use it
This repository contains subdirectories, which usually hold Vagrant Scripts and Ansible playbooks. Furthermore, there are README files for each environment, with a step by step installation guide.

**Installation**
1. Clone this repository: `git clone git@github.com:zwoefler/Testing-Environments.git`
2. Change directory in your desired environment-folde: `cd DESIRED_FOLDER`
3. Follow the installation and setup steps in the README, you find there