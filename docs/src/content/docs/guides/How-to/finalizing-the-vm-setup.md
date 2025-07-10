---
title: How to Finalize the vJailbreak VM Setup
description: Configuring Network for Controller Initialization
---

This is a mandatory, one-time configuration process that must be performed after deploying the vJailbreak VM for the first time.

## Prerequisites

Before you begin, ensure you have:
* A successfully deployed vJailbreak VM using the qcow2 image.
* SSH access to the newly created vJailbreak VM.
* The IP addresses and corresponding hostnames for your OpenStack environment's endpoints.
* `kubectl` access configured to manage the cluster where vJailbreak is running.


## Configuration Steps

### Step 1: Add OpenStack DNS Entries to the VM

First, you need to add the DNS records of your OpenStack environment to the VM's hosts file.

1.  SSH into your vJailbreak VM.
2.  Open the `/etc/hosts` file using a text editor like `nano` or `vi`:
    ```bash
    sudo nano /etc/hosts
    ```
3.  Add the IP address and hostname mappings for your OpenStack environment. It should look similar to the example below.
    ```
    # /etc/hosts

    127.0.0.1      localhost
    # Add your OpenStack environment entries below
    10.12.13.14    keystone.openstack.local
    10.12.13.15    glance.openstack.local
    10.12.13.16    nova.openstack.local
    ```
4.  Save the file and exit the editor.

### Step 2: Restart the vJailbreak Controller Pod

Next, you must restart the controller pod to make it aware of the new network configuration. This is done by scaling the deployment down to zero and then back to one.

1.  Scale down the controller deployment to terminate the running pod.
    ```bash
    kubectl scale deployment -n migration-system migration-controller-manager --replicas 0
    ```
2.  Wait for the controller pod to terminate. Run the following command and check that the `migration-controller-manager` pod is no longer listed before proceeding.
    ```bash
    kubectl get pods -n migration-system
    ```
3.  Scale the deployment back up to create a new pod.
    ```bash
    kubectl scale deployment -n migration-system migration-controller-manager --replicas 1
    ```

## Verification

Your vJailbreak VM is now fully configured! The controller pod will start, and operations requiring access to OpenStack services, such as adding credentials, should now function correctly.

You can check the logs of the new pod to ensure it started without any network-related errors:
```bash
kubectl logs -f <your-new-vjailbreak-pod-name> -n migration-system
```