![next.js](https://assets.vercel.com/image/upload/v1607554385/repositories/next-js/next-logo.png)
![docker](https://www.docker.com/sites/default/files/d8/2019-07/horizontal-logo-monochromatic-white.png)

# next-js-docker

A docker configuration for next.js project.
Use this template to build a docker image for the next.js application.

## About the Container

`harden.sh` and some other ideas are taken from [alpine-harden]<https://github.com/ellerbrock/docker-collection/tree/master/dockerfiles/alpine-harden> repo.

As Base Image i use [An official node alpine image](https://hub.docker.com/_/node/) which is lightweight Distribution with a smaller surface area for security concerns, but with enough functionality for development and interactive debugging.

To prevent zombie reaping processes i run [dumb-init](https://github.com/Yelp/dumb-init) as PID 1 which forwards signals to all processes running in the container.

I keep image size lower by following the [Docker's recommendations](https://docs.docker.com/develop/develop-images/dockerfile_best-practices):

1. `.dockerignore` is setup to ignore everything but files needed in production. Please add files/directories specific to your application there.
1. The build is multi-stage, so the final image doesn't have `python` and other packages installed.
1. `RUN` statements contain multiple commands which reduces the number of layers.
