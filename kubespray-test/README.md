# Kubespray environment
This environment simulates four machines, that can be used to run a kubernetes cluster.
To run a kubernetes cluster on these machines, the project `kubespray` is being used.
It is a bunch of Ansible playbooks, that take care of the initialization and installation
of all relevant compontents, needed to run a Kubernetes Cluster on bare metal.
Therefore, you don't need to disable swap, run kuberentes as etcd and otehr configurations using `kubeadm` manually.


# Goal
This repository aims to get familiar with `kubespray`, the installation and setup-process. Therefore the kubespray usage is not fully automated with Ansible scripts!


# Architecture
The testing architexture can be seen in the image below.
![alt text](img/Architecture.png "Architecture")

This environment consists of your `Host`, an `ansible-host` (VM) and some `nodes` VM to run the Kubernetes Cluster.
The `ansible-host` s being used, to run `Kubespray` and serves as an external Load Balancer. This is, so you don't need to have Ansible installed on your host.

In the following document, your local machine ist refered to as `Host`, the machine running Ansible and setting up the Cluster is refered to by `ansible-host` and every other Node is referenced as `nodeX`, with `X` being a number.


### Machines
The setup consists of four machines:
- 1 Ansible Host - runs Ansible and deploys the cluster to the working nodes
- 3 VMs - These `nodes` actually run the kubernetes cluster.

From the Ansible host you can reach every machine via SSH. Below, you find a list of the machines IP addresses:

| VM | IP |
| --- | --- |
| Ansible Host | 192.168.33.10 |
| Node1 | 192.168.33.20 |
| Node2 | 192.168.33.30 |
| Node3 | 192.168.33.40 |

### Users
Each machine has the user `root` and `vagrant`. The SSH keys are set up, so you don't need a password to enter the machines. In case you do, the passwords are listed below:

| User | Password |
| --- | --- |
| root | root |
| vagrant | vagrant |





# How to use it?

## Prerequisites
##### VM Provider
THis example uses Vagrant to provide the Virtual Machines, but any other
Provider should be fine.
In case you want to follow this repository in the intentioned way, install Virtual Box.
Should you prefer to use an alternative, Create 4 VMs, provision one of the machines with the `setup-ansible-host.yml` playbook, and the remaining machines with the `setup-worker-node.yml` playbook.

On Ubuntu install VirtualBox via:

`sudo apt install virtual-box`

##### Vagrant
To run a cluster locally, on your machine, you need vagrant, to setup VMs easily, with the included `Vagrantfile`.

On Ubuntu install Vagrant via:

`sudo apt install vagrant`

##### Kubernetes
Once the VM setup is done, you will need kubernetes kubectl to control your Kubernetes cluster.


Install Kubernetes kubectl binary with curl:

1. Download the latest release with the command:

    ```curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl```


    To download a specific version, replace the $(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) portion of the command with the specific version.

    For example, to download version v1.17.0 on Linux, type:

    `curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl`

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


## Set Up
##### Initial SetUp
These steps are performed on your `Host`.

1. Install the [prerequisites](#Prerequisites)
2. Clone this repository via git clone: `git clone git@github.com:zwoefler/Testing-Environments.git`
3. Change Directory into kubespray-test: `cd Testing-Environments/kubespray-test`
4. Run the Vagrantfile: `vagrant up`. It can take some time (several minutes) to create the machines and provisioning with ansible.

With the commands above, you now should have 4 machines up and running on your `Host`. Now its time to use `kubespray` to install the cluster on these VMs. All machines are already provisioned with set up SSH-Keys, Python3, kubespray and other dependencies. You can now SSH into each machine, using the IPs which you can see in the console output. Further information can be found in the [Machines](#machines) section.
Continue Reading the [Using Kubernetes](#using-kubernetes) section.
Run `vagrant status` and you should see an output, similar to the following table:

Current machine states:

ansible-host              powerd on (virtualbox)
node1                     powerd on (virtualbox)
node2                     powerd on (virtualbox)
node3                     powerd on (virtualbox)


##### Setup Kubespray
Your VMs are up, running and already provisioned. Now its time to use `kubespray`, to deploy our cluster.
From your `Host` we will now log into the `ansible-host` and provision our Node-machines from there.


1. Log into our Ansible-host machine:
`vagrant ssh ansible-host`

2. Once you are logged into the machine, change directory to kubespray:
`cd kubespray`

3. Copy the folder `inventory/sample` to `inventory/mycluster`. This copys the `sample` folder and serves as a template for our cluster.:
`cp -rfp inventory/sample inventory/mycluster`

4. Now, we need to tell kubespray, which machines it should use to run the cluster. Kubespray comes with a handy script, that generates an Ansible-Host file for you. Declare your node IPs with the following command:
`declare -a IPS=(192.168.33.20 192.168.33.30 192.168.33.40)`

Of course you are free to add additional machines to the list.

5. Afterwards, build the Ansible-host file, using the kubespray `inventory-builder`:
`CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}`

This creates a `hosts.yml` in your `mycluster` folder, that is being used for provisioning the nodes in the following step.

6. Last but not least, run the Ansible playbook that creates your kubernetes cluster via:
`ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml`.
Be warned, this step might take 20 minutes or more!

Finishing this step, you now have a running Kubernetes Cluster on several virtual machines. Congratulations!
To use your cluster productivly, install `kubectl` on your `Host`. More information is found in the [next section](#use-your-cluster).


##### Setup Kubernetes on your Host
You have now a running Cluster, now its time to use and configure it.
We now need to copy the kubernetes `admin.conf` from the master node `node1` to our local system.
FOr that, we need the IP address of our master node.
On your `Host`, follow the steps below:
1. Create, if not already done, your local `.kube`-folder:
`mkdir -p ~/.kube`

2. Download the kubeconfig file from one of the masters, in this case, from `node1`:
`scp root@192.168.33.20:/etc/kubernetes/admin.conf ~/.kube/config`

We safecopy the `admin.conf` file from our `node1`, and paste it into our local `~/.kube` folder.

3. Now you should be able to run `kubectl` commands. Use the following command, to show you a list of the running nodes:
`kubectl get nodes -o wide`

4. Additional commands to gather some informaion are
`kubectl cluster-info` and `kubectl -n kube-system get pods`

Now we have setup our cluster and can use our local installation of `kubectl` to run some containers.


##### Test the interport communication
In order to test, if the installation worked correctly, we test the interport communication
by creating two `busybox` containers, each on one node.

1. Open one terminal session on your host machine and create the busybox container, running a shell:

`kubectl run myshell -it --rm --image busybox -- sh`

You will be prompted with a new shell, running in your busybox

2. Open a second temrinal, and run `kubectl get pods -o wide`. In the `node`-column, it is specified, on which node your container runs.
3. Start a third terminal, and run a second budybox container in your cluster via:

`kubectl run myshell2 -it --rm --image busybox -- sh`

4. MISSING PING OTHER CONTAINERS!!!!



## Upgrade Kubernetes Version
Once your cluster is up and running, you maybe want to update the kubernetes version that is used. You can do this very easily with the following steps. On the `ansible-host` machine we will make some changes.

1. So first, login to your ansible-host:
`vagrant ssh ansible-host`

2. Change into the kubespray directory:
`cd kubespray`

3. Edit the variables used for the cluster. Here we use VIM to change our files:
`vim inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml`

4. In the opened document, search for `kube_version` by typing `/kube_version` in vim and hit enter. Pressing `n` will cycle through the selected and found words.

5. Once you found `kube_version` change it to your desired version and save the file by pressing `ESC` --> `:wq`

6. Now run the `upgrade-cluster` playbook via:
`ansible-playbook -i inventory/mycluster/hosts.yaml --user root upgrade-cluster.yml`


### Example
1. Run two nginx container: `kubectl run nginx --image nginx --replicas 2`
2. `watch -x kubectl get nodes,pods -o wide`
3. Run the steps from [#upgrade-kubernetes-version]
You will see that nodes are getting shut down and recreated. Kubespray is taking care of all the upgrading process and managing the two nginx containers that we set up.




## Adding and Removing Nodes
To actually see what happens, I advise you to run the watch command on `kubectl get nodes` in a seperate terminal.

`watch -x kubectl get nodes`

Either adding or removing a node, reqires you to be logged into the `ansible-host` via
`vagrant ssh ansible-host` and change directory into `kubespray`: `cd kubespray`.

## WORK IN PROGRESS
### Adding a node
Within the `kubespray` directory we now need to edit the `hosts.yml`, used by Kubespray, to setup your nodes.
In this example, we will add a fourth node named `node4` to the cluster.

1. Edit the inventory file. We will open it with VIM:
`vim inventory/mycluster/hosts.yaml`

2. WIthin the `hosts.yml`, add a node to the `all: hosts:` section, and provides its IP address.
    ```
    node4:
      ansible_host: 192.168.33.50
      ip: 192.168.33.50
      access_ip: 192.168.33.50
    ```
3. The previously created node `Node4` now must be added to one of the children-groups. If you want to add `Node4` as a worker node, add it to `kube-node` group, like so:

```
[...]

children:
    kube-master:
      hosts:
        node1:
        node2:
    kube-node:
      hosts:
        node1:
        node2:
        node3:
        node4:

[...]
```

5. Save your changes (`:wq`) and run the ansible playbook `scale.yml` with the now changed `hosts.yml`: `ansible-playbook -i inventory/mycluster/hosts.yaml --user root scale.yml`

You have successfully added a fourth node to your cluster, which is production ready.


### Removing a node
Removing a node is as simple as running the `remove-node.yml` playbook, with the additional parameter of the nodes, that you want to delete. Below is the command to remove the previously created `node4`. Removing more than one node is as simple as just appending the nodes to the extra-vars.

1. To remove a node, run these commands on the `ansibe-host` in the `kubespray` directory.

- Remove `Node4`:
`ansible-playbook -i inventory/mycluster/hosts.yaml --user root remove-node.yml --extra-vars "node=node4"`


- Remove multiple Nodes, `Node4` and `Node3`:
`ansible-playbook -i inventory/mycluster/hosts.yaml --user root remove-node.yml --extra-vars "node=node4,node3"`

As you can see, we executed the `remove-node.yml`, providing it with the inventory file for our cluster and a list of nodes, that we want to no longer use.

2. In case you want to make your removal permantent, rebuild your inventory file to remove the no longer needed nodes from the `inventory/mycluster/hosts.yml`. Otherwise, when you recreate your cluster, it will use all hosts pre-removal.



## Reset the Cluster
In case, that you need your machines back, or for something different, withot kubernetes nodes running on them, you can simply reset the
cluster machines. This will undo the cluster provisioning and everything that was installed during the kubespray installation process.

Be logged into your `Ansible-host` VM via: `vagrant ssh ansible-host`

1. Change directory into kubespray directory: `cd kubespray`

2. Run the `reset.yml` playbook as root user with:
`ansible-playbook -i inventory/mycluster/hosts.yml --user root reset.yml`

3. Accept the deletion of your cluster by typing `yes` into the prompt.

BOOM, your cluster is gone.
To prove it, run `kubectl get nodes` on your `Host`.




## Configure a Loadbalancer
So far, our cluster used the internal proxy. We will change this to a proxy of our choice, either `haproxy` or `nginx`.
Instead of using a seperate machine, we will use our `ansible-host`. Because we are just running playbooks form it, we will use it to run something productive!
So to start of, from your host log in to the `ansible-host` via: `vagrant ssh ansible-host`

1. Install haproxy: `apt update && apt install -y haproxy`
2. Edit haproxys configuration:
`vim /etc/haproxy/haproxy.cfg`

3. Add some configuration:
```
listen kubernetes-apiserver-https
  bind 192.168.33.10:8383
  option ssl-hello-chk
  mode tcp
  timeout client 3h
  timeout server 3h
  server master1 192.168.33.20:6443
  server master2 192.168.33.30:6443
  balance roundrobin
```
4. Restart the haproxy service!
`sudo systemctl restart haproxy`

5. SetUp the SSH-Keys
6. Clone kubespray and install kubespray
7. Specify that we are using an external loadbalancer:
`vim inventory/mycluster/group_vars/all/all.yml`
8. Uncomment the External LB example config section
9. Set the IP Address and Port and domain-name
10. Uncomment the line and set it to false `loadbalancer_apiserver_localhost: false`
11. On your localhost, add the IP and domain to oyur /etc/hosts
12. On the Ansible-host, rerun the cluster
`ansible-playbook -i inventory/mycluster/hosts.yml --user root cluster.yml`
13. On Localhost, get kube config to localhost!
14.



## ToDos


- Implement a way, to vary the amount of nodes
    - Automatically adjust the amount of nodes, to the systems resources

- Create roles out of the spaghetti playbooks!

- Parallize the Provisioning process of the VMs

- [ ] Output the IP addresses of the VMs with their corresponding nodes

- [ ] Add a machine, provision it and use it as an additional node - Automatically:
    - [ ] Script to add Vagrant machine
    - [ ] Provision the machine
        - [ ] SSH keys
        - [ ] Software
        - [ ] Users
        - [ ] ...
    - [ ] Automate the adding a node to the cluster [#adding-and-removing-nodes]

- [ ] Automated README script
    - [ ] List of hosts in File - Building the tables for the machines automatically
    - [ ] Put IP-addresses into the the commands
    - [ ] Automated Table of Contents
