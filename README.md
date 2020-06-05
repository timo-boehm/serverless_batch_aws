# Serverless Batch Jobs on AWS

## Overview

This code repository is supplemental material for four blog posts in total:

1. A conceptual overview and motivation why to choose a serverless architecture and how it looks like [here](https://blog.codecentric.de/en/2020/06/cost-effective-batch-jobs-on-aws-serverless-infrastructure/).
2. A technical deep dive on the required network resources and settings here (LINK).
3. A technical deep dive on the required roles and polices here (LINK).
4. A technical deep dive on the actual services and their configurations here (LINK).

As you can see, each technical deep dive focuses on one of the CloudFormation scripts in the `aws` folder. In the case
of a real-world implementation, the unlimited access to all resources in the policies need to be restricted!

## How to Use this Repository

This repo is meant to help you gather your own experiences:

- You can play around with the application code and see whether things still work as expected. If not, the debugging
will teach you a lot about how AWS in combination with CloudFormation works.
- You can check out the YAML scripts and work through the parameter settings.
- You can add additional services, e.g., notifications for successful code builds.
- ...

To setup the infrastructure, you need to run the `setup.sh` file in the `aws` folder. To make it work, you have to
install autostacker24 (LINK) and install the AWS CLI on your machine. If you prefer to use the browser, you can also
directly upload the YAML files into CloudFormation.

> Note: right now, you have to delete the stacks manually if you want to get rid of
> them. Feel free to write a teardown script and I will happily add it here. :)

Get in touch if you have any questions and I'll try to answer them!

## Details about Files and Folders

1. app -> Python Code for Batch Job and requirements.txt
2. aws -> Cloudformation YAML-Files and setup script
3. Building Files (Dockerfile and buildspec.yml)
4. Supporting Files (example file for minimalistic python app)

### Setup Infrastructure

There are three __CloudFormation__ YAML files and one `setup.sh` file to send them to AWS.

The YAML files cover the networking aspects of the service, the necessary IAM roles and policies and
the actual resources and their interaction.

The `setup.sh` file also includes some additional code to upload an initial state of the app
code and an exemplary file from the `supporting` folder.

### Building Files

The `Dockerfile` is as straightforward as possible. It takes `python:3.8-slim` as the base
image, installs the required python libraries from the `requirements.txt` file and executes the `main.py` script when 
run.

The `buildspec.yml` file is used by AWS' __CodeBuilt__ service. For this purpose,
it has three phases:

1. Make sure the connection to the container registry works as expected.
2. Build and tag a Docker image according to the `Dockerfile` of this repo.
3. Push the resulting Docker image to the container registry service.

The environment variables are provided by the __CodePipeline__.

### Supporting Files

The only supporting file (for now) is a minimalistic text file. `setup.sh`
uploads it to the data bucket so that the python application has something
to work with.