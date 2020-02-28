# How to use Kubernetes Secrets
This directory show you, how to use, create and delete Secrets in Kubernetes Clusters. To have an overview of the used command, have a look at the [commands](#commands)-section.
Kubernetes already has a pretty extensive documentation. However, in this repository, it is reduced to some basic understanding and a few real-world examples.

## Why use Secrets
You want to have some login credentials. Either hard code the Password into the container image **or** create a Secret Resource, that can be pulled from the secret file by the container.

By default, your cluster already has a secret.
You can see it with the command `kubectl get secrets`.

### Create a Secret manually
So in order to create a secret manually, from a yml file, you can have a look at the `secrets.yml` file in this repository.

In the section `data`, you will find two keys (`username` and `password`) and some corresponding values. The values have to be base64 encoded!

Once you understand the structure of the yaml file, you can use `kubectl` to create new secrets, based on this yml-file. In the following example, we will create some login credentials `username: Test-User` and `password: Test-Password`.

#### Create the Secret manually
1. Make sure, your `kubectl` works accordingly. `kubectl get pods`

2. Encode your secret values with base64, like so: `echo -n 'Test-User' | base64` which yields the following output: `VGVzdC1Vc2Vy`
3. Paste the output into your yml file, to the appropriate key
4. Repeat the above steps for the password as well: `echo -n 'Test-Password' | base64`, which yields the the output: `VGVzdC1QYXNzd29yZA==`
5. Save your secrets.yml file and create the secret using: `kubectl create -f secrets.yml`
The console should tell you, that a secret has successfully been created.

Your yaml-file should look like this:
```
apiVersion: v1
kind: Secret
metadata:
  name: secret-demo
type: Opaque
data:
  password: VGVzdC1QYXNzd29yZA==
  name: VGVzdC1Vc2Vy
```

Now you have created the secret for your cluster. To check if everthing worked, run the following command: `kubectl get secrets`.

The output should be similar to this:
```
NAME                  TYPE                                  DATA   AGE
default-token-np4j2   kubernetes.io/service-account-token   3      47h
test-secret           Opaque                                2      59s
```

You see, there are already two secrets know to your cluster. To get more details, you can either use on the these two commands:
* `kubectl get secret test-secret -o yaml`
* `kubectl describe secret test-secret`

The latter one, gives you less information, and doesn't show the actual values of you secret.

Using one file, allows you to quickly generate a secret with a lot of key-value pairs. It is also a nice way of getting to know, how Secrets work in Kubernetes.



#### Create a secret using kubectl
To create a secret with oyu command line interface, using kubectl, requires nothing more, than either files, containing your secret-values or the literal written to the console.

Let's take the example from above. We have some login credentials, that are required for a pod to access some other service, e.g a database. These login credentials constist of a `username` and `password` and can be stored in a file named `username` and `password`.

Creating these files is as simple as writing the following:

```
echo -n 'Tast-User` > username
echo -n 'Test-Password' > password
```

Using the `kubectl create secret` command in conjunction with the `from-file` arguments, creates a new Secret:

`kubectl create secret generic login-credentials --from-file=username --from-file=password`

Using the `from-literal` argument, creates a secret, directly from literals given as arguments to the `kubectl create secret` command. Keep in mind, that special characters, like `$`, `*` and `!`, etc. need to be escaped, usually with surrounding single quotes `'`:

`kubectl create secret generic login-credentials --from-literal=username=Test-User --from-literal=password=Test-Password`


The console output should be similar to `secret "login-credentials" created`.

Checking the `kubectl get secrets` command will output you something similar to:

```
NAME                  TYPE                                  DATA      AGE
login-credentials     Opaque                                2         51s
```


### How to use Secrets in Pods
Secrets will be mounted as individual files or environment variables in your Containers.


#### Secrets as Volume


#### Secrets as Environment
To make a pod use a secret, it must reference it explicitly in the pod definition. The environment variable that consumes the secret key should populate the secret's name and key in `env[].valueFrom.secrteKeyRef`.
Find a appropriate pod in the `env-secret-pod.yml`-file.


**`env-secret-demo.yml` content:**
```
apiVersion: v1
kind: Pod
metadata:
  name: test-env-pod
spec:
  containers:
  - name: test-env-container
    image: redis
    env:
      - name: secret-password
        valueFrom:
          secretKeyRef:
            name: login-credentials
            key: username
      - name: secret-password
        valueFrom:
          secretKeyRef:
            name: login-credentials
            key: password
  restartPolicy: Never
```

As you can see in the yaml file above, the `login-credentials`, the secret that we have created in the steps above, is referenced. In order to use secret variables, the environment variable, that consumes the secret, needs to be referenced exactly. So in this example we reference our `login-credentials` and specifically the keys `username` and `password`.

Createa a pod in your cluster, with this yml file and use `kubectl create -f env-secret-demo.yml`

Run `kubectl get pods` to see if your pod is alreaddy running. Afterwards run `kubectl exec -it test-env-container -- sh`, which runs a shell inside your container.
Inside the Container Shell, type in `env | grep secret-password`


### Create a Secret containing SSH-Keys
Storing passwords and usernames might be a useful tasks, but what about SSH-Keys?
If you have paid attention, SSH-Keys are just files, and we already know, how to create secrets, out of files. So, on our kubectl machine, we will create the SSH-Key-Pair

`kubectl create secret generic ssh-key-secret --from-file=ssh-privatekey=/path/to/.ssh/id_rsa --from-file=ssh-publickey=/path/to/.ssh/id_rsa.pub`




## Commands

| Intention | Command |
| --- | --- |
| Show all Cluster Secrets | `kubectl get secrets` |
| Get Secret information in yaml format | `kubectl get secret test-secret -o yaml` |
| | |