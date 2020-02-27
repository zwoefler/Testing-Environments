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

#### Create the Secret
1. Make sure, your `kubectl` works accordingly. `kubectl get pods`
*. Encode your secret values with base64, like so:
`echo -n 'Test-User' | base64`
*. Paste the output into your yml file, to the appropriate key
*. Repeat the above steps for the password as well:
`echo -n 'Test-Password' | base64`
*.


## Commands

| Intention | Command |
| --- | --- |
| Show all Cluster Secrets | `kubectl get secrets` |