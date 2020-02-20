# Kubespray environment
This is a kubespray testing repository with a Vagrantfile to start asap.
4 machines (Ubuntu) are created, connected to a private network.

# Architecture
The architexture can be seen in the image below. From your host, several machines are set up with Vagrant. One of which is there to provision all Nodes. This is, so you don't need to have Ansible installed on your host.

![alt text](img/Architecture.png "Architecture")



# How to use it?

### Prerequisites
##### VM Provider
You need a virtual machine provider like virtual box.

On Ubuntu install VirtualBox via:
`sudo apt install virtual-box`

##### Vagrant
To run a cluster locally, on your machine, you will also need vagrant, to setup VMs easily.

On Ubuntu install Vagrant via:
`sudo apt install vagrant`

##### Kubernetes
Once the VM setup is done, you will need kubernetes kubectl to control your Kubernetes cluster.

On Install Kubernetes kubectl binary with curl:

1. Download the latest release with the command:
    `curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl`


    To download a specific version, replace the $(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) portion of the command with the specific version.

    For example, to download version v1.17.0 on Linux, type:

    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl

2. Make the kubectl binary executable:
    `chmod +x ./kubectl`

3. Move the binary in to your PATH:
    `sudo mv ./kubectl /usr/local/bin/kubectl`

4. Test to ensure the version you installed is up-to-date:
    `kubectl version --client`


On Ubuntu install Kubernetes kubectl via:

```
sudo apt-get update && sudo apt-get install -y apt-transport-https`
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```


### Installation
1. Install the [prerequisites](#Prerequisites)
2. Clone this repository via git clone: `git clone git@github.com:zwoefler/Testing-Environments.git`
3. Change Directory into kubespray-test: `cd Testing-Environments/kubespray-test`
4. Run the Vagrantfile: `vagrant up`. It can take some time (several minutes) to create the machines and provisioning with ansible






## ToDos
1. Initialize the 4 machines, 3 nodes, 1 ansible master
*. Install Ansible on the Ansible-master
*. Generate SSH Key-Pair on Ansible host
*. ssh-copy-id to remaining three nodes

- Implement a way, to vary the amount of nodes
    - Automatically adjust the amount of nodes, to the systems resources