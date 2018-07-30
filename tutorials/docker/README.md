# Docker

Docker is a tool that is designed to make it easier to create and run applications
by using containers. A container is a virtual environment that allows a developer to
package an application with all of the necessary ingredients (requirements) for
it to run, and bundles it up into one portable package.  While simple in concept,
this is a very powerful tool that allows you to create computing environments
that can be replicated on most modern computers. Here are a few example use
cases for a scientist:
- A sharable computing environment so that all members of your lab have access
to the same tools
- An easily replicable experiment that can be run from anywhere.
- An analysis pipeline with all of the necessary code to replicate figures and
  statistics from a published paper.
- An application that runs Jupyter server so that you can access the same
data and software without installing anything locally.

# Getting started at MIND:

+ Follow Eshin's instructions in the README found [here](https://github.com/Summer-MIND/mind-tools)


# Getting Started on you own:

+ Install [Docker](https://www.docker.com/) and [Google Chrome](https://www.google.com/chrome/browser/desktop/index.html)

+ Follow the instructions in Dockerfile_example. This file serves as a set of
instructions for building a docker image.

+ To build the docker image, make sure you have docker running, navigate to your
local copy of this repo and execute the line: `docker build -t cdl .`. This will
create a docker image from the instructions you specified in Dockerfile.

+ Once the docker image builds, you can launch it by executing the following
command: `docker run -it -p 9999:9999 --name CDL -v ~/Desktop:/mnt cdl`. To
unpack this, `run` runs the image. `-it` starts the container as an interactive
process (like a shell). `-p` opens and links a port on the docker to a port on
your local computer. `--name` names the container. `-v` allows you to share a
volume between the docker container and your local computer. `cdl` at the end
specifies which image you want to run. For more details on `docker run`, see
[this](https://docs.docker.com/engine/reference/run/) link. You should now see
the root@ prefix in your terminal, if so you've successfully created a container
and are running a shell from inside!

+ Launch the demo jupyter notebook:
`jupyter notebook demo.ipynb --port=9999 --no-browser --ip=0.0.0.0 --allow-root` and then
navigate to `localhost:9999` (+ a token) in your browser to access the notebook.

<!-- ## Table of contents

- [Dockerfile](https://github.com/ContextLab/Tutorials/blob/master/Tutorial%20Template/requirements.txt)- List of dependencies for this tutorial, able to be automatically installed via `pip`.
- [data](https://github.com/ContextLab/Tutorials/tree/master/Tutorial%20Template/Data)
   - [example data creation](https://github.com/ContextLab/Tutorials/blob/master/Tutorial%20Template/Data/Example_Data_Creation.ipynb)- Notebook containing an example of how to create and save data
  - [chirp.npy](https://github.com/ContextLab/Tutorials/blob/master/Tutorial%20Template/Data/chirp.npy)- Npy file of the example dataset  
  - [downloading data example](https://github.com/ContextLab/CDL-tutorials/blob/master/tutorial_template/data/downloading_data_example.ipynb)- example of how to download data from on line and source it in the text, data from [here](http://scikit-learn.org/stable/modules/generated/sklearn.datasets.load_iris.html#sklearn.datasets.load_iris)
  - [iris.npy](https://github.com/ContextLab/CDL-tutorials/blob/master/tutorial_template/data/iris.npy)- saved file of data created and analyzed in "Downloading data example"
- [notebooks](https://github.com/ContextLab/Tutorials/tree/master/Tutorial%20Template/Notebooks)- Folder containing Jupyter Notebooks
  - [demo](https://github.com/ContextLab/Tutorials/blob/master/Tutorial%20Template/Notebooks/Demo.ipynb)- Analyzing the sample data
- [slides](https://github.com/ContextLab/Tutorials/tree/master/Tutorial%20Template/Slides)
  - [slides.txt](https://github.com/ContextLab/Tutorials/blob/master/Tutorial%20Template/Slides/Source.tex)- Txt format for the slide show- copy and paste into Overleaf as a template to make your own show
  - [slides.pdf](https://github.com/ContextLab/Tutorials/blob/master/Tutorial%20Template/Slides/template%20slideshow.pdf)-Pdf presentation of the tutorial
  - [figs](https://github.com/ContextLab/Tutorials/tree/master/Tutorial%20Template/Slides/figs)- Folder containing figures for the slideshow
    - [make figure](https://github.com/ContextLab/Tutorials/blob/master/Tutorial%20Template/Slides/figs/make_figure.ipynb)- Code to make the figure in the slideshow
    - [sin](https://github.com/ContextLab/Tutorials/blob/master/Tutorial%20Template/Slides/figs/sin.pdf)- PDF version of slide show figure -->

## Helpful commands

- See what docker images you have downloaded and can be used to create new containers:  
	+ `docker images`  
- See running container dockers:  
	+ `docker ps`  
- See all docker containers you have created (including those not running):  
	+ `docker ps -a`
- Startup and connect to previously created container:
	+ `docker start yourContainerName`
	+ `docker attach yourContainerName`
- Delete a docker container:  
	+ `docker rm yourContainerName`  
- Delete a docker image:  
	+ `docker rmi yourImageName`  
- Stop a running container:  
	+ `docker stop yourContainerName`
- Execute a new command in an existing docker container
	+ `docker exec yourContainer command`
- Delete all containers that are no longer running:
	+ `docker rm $(docker ps -aq -f status=exited)`
- Force delete ALL containers
	+ `docker rm -f $(docker ps -aq)`
