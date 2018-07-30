# Introduction to Git and Github

This is a brief introduction to git and github. Conceptual overview slides are available as well as a quick reference guide and a more comprehensive command list.  

Below are examples of the more common commands you're likely to used regularly.  

## Most common commands  

`git status`  
see what files are ready to be made into a "snapshot" (committed) and which ones are not being kept track of  
![git status](./example_command_gifs/gitstatus.gif)  

`git init`  
create a new git repository for the first time (will not add any files)  
![git init](./example_command_gifs/gitinit.gif)  

`git add`  
add file(s) to the list of files that should be made into a "snapshot" (committed)
![git add](./example_command_gifs/gitadd.gif)  

`git commit`  
take a "snapshot" of all currently tracked project files. Files need to be "prepped" (staged) for commit using `git add` beforehand.    
![git commit](./example_command_gifs/gitcommit.gif)  

`git log`  
see the full historical timeline of the project  
![git log](./example_command_gifs/gitlog.gif)  

`git push`  
send latest local changes to a remote location (e.g. github)  
![git push](./example_command_gifs/gitpush.gif)  

`git pull`  
get the latest changes from a remote location (e.g. github)  
![git pull](./example_command_gifs/gitpull.gif)  

`git clone`  
duplicate a remote repository (e.g. github) on your local computer  
![git clone](./example_command_gifs/gitclone.gif)

`git branch`  
create a new independent "timeline" for the project  
![git branch](./example_command_gifs/gitbranch.gif)  

`git revert`  
undo changes by reversing any specific "snapshot" (commit)  
![git revert](./example_command_gifs/gitrevert.gif)  

`forking`  
copy a remote repository on github, to your own remote account on github  
![git fork](./example_command_gifs/gitfork.gif)  

`pull request`  
notify a remote repository owner you would like them to review+incorporate your additions  
![pull request](./example_command_gifs/pullrequest.gif)
