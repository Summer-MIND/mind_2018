# simple example of a Dockerfile
FROM ubuntu:latest
MAINTAINER Contextual Dynamics Lab "contextualdynamics@gmail.com"

# install python and flask
RUN apt-get update
RUN apt-get install -y python python-pip wget
RUN pip install Flask

# add a script
ADD simple_server.py /home/simple_server.py

# set the working directory
WORKDIR /home
