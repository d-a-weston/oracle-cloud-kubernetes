# oracle-cloud-kubernetes

Creating a Kubernetes cluster utilising the free tier of Oracle Cloud Infrastructure

## Basic Setup

1. Create your Oracle Cloud account [here](https://www.oracle.com/au/cloud/sign-in.html)
2. Goto your profile, then scroll down to find API Keys
3. Add an API Key (follow all the instructions)
4. Create `terraform.tfvars` in the root of this repo
5. Fill in your vars from the config file

```
tenancy_ocid    = "tenancy"
user_ocid       = "user"
key_fingerprint = "fingerprint"
region          = "ap-sydney-1"
```

6. Run `terraform init`
7. Run `terraform apply`
8. Enjoy!
