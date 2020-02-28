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

#### Create the Secret with one file
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

So for the next step, we will delte our created secret


## Commands

| Intention | Command |
| --- | --- |
| Show all Cluster Secrets | `kubectl get secrets` |
| Get Secret information in yaml format | `kubectl get secret test-secret -o yaml` |
| | |