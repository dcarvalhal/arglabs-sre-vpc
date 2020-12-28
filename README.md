# About arglabs-sre-vpc

This is part of the [ARGLabs project](https://www.arglabs.com.br).

See more about this on [Github repository](https://github.com/ARGLabs/arglabs-sre-vpc) and this [blog post](https://arglabs.com.br/2020/11/19/the-vpc-infrastructure/).

### Why ?

Usually created by an Infrastructure team (nowadays named devops, SRE or an Infrastructure Mechanic like me), all the very basic infrastructure should be on it's own repository.

### What this repo does ?
Creates the basic infrastructure like VPC, Subnets, route tables, internet gateway, nat gateways, transit gateway etc and provides all the outputs needed for other projects.

It should not be used for service or application specific resources. 

DO NOT create any databases, load balancers, instances etc here.

### Highlights
If done right, you don't need to change any code in this repo to add another environment or change CIDRs. Just configure it on deep-thought and use it everywhere else.

# How to use it

### Dependencies
You need the [deep-thought](https://arglabs.com.br/2020/11/17/deep-thought-all-the-answers-you-will-need/) applied before.

### run.sh script
Usage:
```shell
# ./run.sh 
./run.sh <apply|destroy|plan> <workspace>
```

So, to run it on the global workspace:
```
 ./run.sh apply global
```
Expect something like this output [Youtube video](https://www.youtube.com/watch?v=Wy4XmQjpODM)

### How it will be used by other projects
As an external data source, like this:

```
data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = var.bucket
    region = var.bucket_region
    key    = "infra/sre/vpc.state"
  }
}
```
And then you can use any output you want:
```
data.terraform_remote_state.vpc.outputs.<output you want>
```

# Help
### How to get help
If you have found a bug or couldn't run this part of the lab, please open an issue as a bug report on this project.

### How to help
If you have any ideas to make this part of the lab better, please open an issue as a feature request for this project.
If you want to see something new on this lab and you can help me with it, please submit a feature request issue on [this project](https://github.com/ARGLabs/arglabs)

