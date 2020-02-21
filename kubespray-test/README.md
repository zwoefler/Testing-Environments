# Kubespray environment
This environment simulates four machines, that can be used to run a kubernetes cluster.
To run a kubernetes cluster on these machines, the project `kubespray` is being used.
It is a bunch of Ansible playbooks, that tae care of the initialization and installation
of all relevant compontents, needed to run a Kubernetes Cluster on bare metal.


# Goal
This repository aims to get used to `kubespray`, the installation and setup-process. Therefore the kubespray usage is not fully automated with Ansible scripts!

# Architecture
The architexture can be seen in the image below.
![alt text](img/Architecture.png "Architecture")

THis environment consists of your `Host`, an `ansible-host` (VM) and some `nodes` VM to run the Kubernetes Cluster.
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
Each machine has the user `root` and `vagrant`. The SSH keys are set up, sos you don't need a password to enter the machines. In case you do, the passwords are listed below:

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

    `curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl`


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


### Set Up
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
To use your cluster productivly, install `kubectl` on your `Host`. More information is found in the [next section](#use-your-cluster)


### Use your Cluster
After the setup is finished, you can use your kubernetes Cluster.
On your host-machine (Not one of the vagrant machines) get your kubernetes cluster information
1. Create, if not already done, your local `.kube`-folder: `mkdir -p ~/.kube`
2. Download the kubeconfig file from one of the masters, in this case, from `node1`: `scp root@192.168.33.20:/etc/kubernetes/admin.conf ~/.kube/config`.
3. Now you should be able to run `kubectl` commands. Try
`kubectl get nodes -o wide`.
4. `kubectl cluster-info`, `kubectl -n kube-system get pods`


### Test the interport communication
See if interport communication works by starting two `busybox` containers, each on one node.

1. Open one terminal session on your host machine:

`kubectl run myshell -it --rm --image busybox -- sh`

2. With `kubectl get pods -o wide` you can see in the `node`-column, where your container runs.
3. In another terminal start a seconds `busybox` via:

`kubectl run myshell2 -it --rm --image busybox -- sh`

## Upgrade Kubernetes Version
We will need to make some changes on the `Ansible-host` machine. To see the changes live, run `kubectl get nodes` in a seperate terminal.

So first, login to your cagrant ansible-`vagrant ssh ansible-host`
`cd kubespray`
`vim inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml`
Search for `kube_version` by typing `/kube_version` in vim and hit enter. With `n` you can cycle through the selection.
`ansible-playbook -i inventory/mycluster/hosts.yaml --user root upgrade-cluster.yml`


### Example
1. Run two nginx container: `kubectl run nginx --image nginx --replicas 2`
2. `watch -x kubectl get nodes,pods -o wide`
3. Run the steps from [#upgrade-kubernetes-version]
You will see that nodes are getting shut down and recreated. Kubespray is taking care of all the upgrading process and managing the two nginx containers that we set up.




## Adding and Removing Nodes
To actually see what happens, I advise you to run the watch command on `kubectl get nodes` in a seperate terminal.

`watch -x kubectl get nodes`


Login to the ansible machine: `vagrant ssh ansible-host` and change into kubespray. `cd kubespray`


### Adding a node
How to add or remove a node using kubespray
1. Edit the inventory file `vim inventory/mycluster/hosts.yaml`
2. In the section `all: hosts:` just add or remove a node and change the IP addresses
    ```
    node4:
      ansible_host: 192.168.33.50
      ip: 192.168.33.50
      access_ip: 192.168.33.50
    ```
3. The previously created node `Node4` now must be added to one of the children-groups. If you want to add `Node4` as a worker node, add it to `kube-node` group, like so:

```
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
```

5. Close vim and run the ansible playbook: `ansible-playbook -i inventory/mycluster/hosts.yaml --user root scale.yml`

### Removing a node
Removing a node is as simple as running the `remove-node.yml` playbook, with some additional parameters. Below is the command to remove the previously created
`node4`. Removing more than one node is as simple as just appending the nodes to the extra-vars.

Remove `Node4`:

`ansible-playbook -i inventory/mycluster/hosts.yaml --user root remove-node.yml --extra-vars "node=node4"`

Remove multiple Nodes `Node4` and `Node3`:

`ansible-playbook -i inventory/mycluster/hosts.yaml --user root remove-node.yml --extra-vars "node=node4,node3"`

So we will execute the Ansible-Playbook `remove-node.yml`, giving it the inventory file for our cluster, using the root user and specify what the name(s) of the nodes is, that we want to delete.

Afterwards build your inventory file new or delete the no longer needed nodes from the `inventory/mycluster/hosts.yml`


## Reset the Cluster
Completely undo the cluster provisioning, everything regarding kubernetes will be undone. Returns you the machines in the given condition.

Be logged into your `Ansible-host` VM via: `vagrant ssh ansible-host`

1. cd into kubespray directory: `cd kubespray`
2. Run `ansible-playbook -i inventory/mycluster/hosts.yml --user root reset.yml`
3. Accept the deletion of your cluster
4. BOOM, your cluster is gone. To prove it, on your host you run `kubectl get nodes`





## Configure a Loadbalancer
Instead of using a seperate machine, we will use our `ansible-host`. Because we are just running playbooks form it, we will use it to run something productive!
So to start of, form your host log in to the `ansible-host` via: `vagrant ssh ansible-host`

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
1. Initialize the 4 machines, 3 nodes, 1 ansible master
*. Install Ansible on the Ansible-master
*. Generate SSH Key-Pair on Ansible host
*. ssh-copy-id to remaining three nodes

- Implement a way, to vary the amount of nodes
    - Automatically adjust the amount of nodes, to the systems resources

- Create roles out of the spaghetti playbooks!

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
