# Testing-Environments
This repository contains different testing environemnts for all kinds of technologies

# The Goal
It must be achieved, that you can test whatever technology you want, by just pressing a button, to create a testing environment, either locally, or without a lot of manual setup-steps, in your cloud-environment.


# How to use it
This repository contains subdirectories, which usually hold Vagrant Scripts and Ansible playbooks. Furthermore, there are README files for each environment, with a step by step installation guide.

**Installation**
1. Clone this repository: `git clone git@github.com:zwoefler/Testing-Environments.git`
*. Change directory in your desired environment-folde: `cd DESIRED_FOLDER`
*. Follow the installation and setup steps in the README, you find there



# Contains
- kubespray-test:
An environment containing Vagrantmachines, provisioned with Ansible to play around with kubespray.