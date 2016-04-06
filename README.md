[dotfiles]: https://github.com/atomantic/dotfiles#readme
[docker_toolbox]: https://www.docker.com/toolbox

# Sample Dockerized app
Generated with [generator-dockerize](https://github.com/atomantic/generator-dockerize)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [What is this?](#what-is-this)
- [Developer Getting Started](#developer-getting-started)
    - [Start and stop the live running app](#start-and-stop-the-live-running-app)
    - [Run Tests](#run-tests)
    - [Debugging The Environment Internally](#debugging-the-environment-internally)
- [Operations](#operations)
  - [Build (Docker image)](#build-docker-image)
  - [Service Deployment](#service-deployment)
  - [Deployment Verification](#deployment-verification)
  - [Live Instances](#live-instances)
  - [Monitoring](#monitoring)
- [Technology Stack](#technology-stack)
- [Directory Structure](#directory-structure)
- [Repo Owner Docs](#repo-owner-docs)
  - [Generate Table of Contents](#generate-table-of-contents)
  - [Readme Directory Tree](#readme-directory-tree)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# What is this?

This is a sample app that uses Docker to automate dev setup and create consistency in deployed environments.
It uses Homebrew to install and maintain docker on OSX.

# Developer Getting Started

This application is built using Docker, which creates a Production equivalent VM environment on your system. It will mount the git repo app directory into the VM so you can still work on your native OS but run the app in a sandbox.

Download and run the setup:
```
git clone git@github.com:atomantic/dockerized.git
cd dockerized
./dev init
# this will make sure docker toolkit is installed and then will launch a docker quickstart shell.
# once you see the new shell prompt, run
./dev start
```

When init completes, it will automatically launch a browser pointing to the running app.

![Running](https://github.com/atomantic/dockerized/raw/master/docs/running.png)

### Start and stop the live running app
If for some reason you need to stop/start the app, you can do so like this:
```
./dev stop
./dev start
./dev restart
```

### Run Tests

```
./dev test;
```

### Debugging The Environment Internally

```
./dev shell
```

# Using This Repo as a Bootstrap

This project is made up of several files, which you can port into your own application to dockerize your developer environment:

## .dockerignore
This file simply tells docker to ignore files and directories in the docker build process.
Chances are, you don't need things like `build_scripts`, `app/test`, `docs`, etc in the docker build.
Adding more to this file will speed up your docker build time since docker has to send all the files in this directory to the docker engine
in order to create the machine. It will omit anything specified in `.dockerignore`

## .env
This file is a runtime ENV declaration. Keep in mind that secrets must be set on the actual system ENV, which ops will use to pass into docker.
Everything else can go in here. Your app will use these settings on your dev machine.

## app/.rsyncignore
We maintain synchronization of your Host OS git repo with the docker container using rsync. This file tells rsync NOT to sync some files and directories. For instance, you probably wouldn't want to rsync something like `node_modules` because some modules will compile differently on OSX vs. CentOS. Part of the system build process is to rebuild packages inside the docker container. If we sync them from OSX they won't work right if we do another build locally. If you find that something is giving you trouble, you can add it to this file.

## dev
The `dev` script is the main developer toolkit script. You can copy this file without modification.



## dev.config.sh
These are the specific configs for your app/environment, which the `dev` script will use to run your app apart from others:
```bash
#!/usr/bin/env bash
# The Github/DockerHUB ORG for your project
export APP_ORG="dtss"
# The repo name for your git/docker hub project
export APP_NAME="dockerized"
# the port to run your app on (change this to something random that won't bump into another app)
export APP_PORT_EXTERNAL=4103
# the port your app listens on (will not conflict with other apps)
export APP_PORT_INTERNAL=3000
# the VM name for the virtualbox VM. You can leave this as dockerized-vm and put all your apps in that virtualbox image
export VM_NAME="default"
# the docker hub repo. Leave this alone for now
export DOCKER_REPO="hub.docker.com:5000"
# The time it takes to create your docker image.
# The app bootstrap will delay launching the browser for this many seconds
# on first `dev init` call
export VM_CREATE_TIME=120
```

## docker-compose.tmpl
At runtime, we will use this as a template for creating the `docker-compose.yml` file, which will add your current working directory as the source for the rsync to the docker nodes. Since this path might be different on multiple developer machines, we use the template and add `docker-compose.yml` to `.gitignore`

## Dockerfile
This is the file that defines your actual Application. This is what will build both your local development environment and your production environment--YES, they are the same!

# Technology Stack
* [Docker](https://www.docker.com/):  Application containerization
* [Node.js](http://nodejs.org/):  Platform for fast, scalable network applications in JavaScript via event-driven, non-blocking I/O model.
* [Hapi](http://hapijs.com/):  Application framework for building web applications & services via node
* [Memcached](http://memcached.org/):  High-performance, distributed memory object caching system
* [PM2](https://github.com/Unitech/pm2):  Process monitoring and load balancing


# Directory Structure
```

├── Dockerfile                     - Docker configuration file
├── README.md                      - This file
├── app/                           - The app itself
├── dev                            - Developer toolkit
├── dev.config.sh                  - configuration for this app
├── dev.init.sh                    - custom dev init script (per project)
├── docker-compose.tmpl            - the docker containers needed for this app (with ports) -- docker-compose.yml is created from this
├── docs/                          - Documentation (swagger, etc)
└── test.sh                        - test script to run against docker container
```
# Repo Owner Docs

## Generate Table of Contents
```
npm install -g doctoc
doctoc .
```

## Readme Directory Tree
```
# brew install tree (if you don't have it)
tree -I 'node_modules|lib'
```
