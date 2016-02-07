export HISTSIZE=50000
export HISTCONTROL=ignoredups

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
# below required to set path for work laptop
export PYTHONPATH=/Users/douglas/growthintel/:$PYTHONPATH

# virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/growthintel
source /usr/local/bin/virtualenvwrapper.sh

# homebrew github token
export HOMEBREW_GITHUB_API_TOKEN=7df0e45e8a8e804ff0f7a6f8c5fcf9cd0c110eaa

# dylan's tunnel helper function
function tunnel {
   ssh -f $1 -L $2:localhost:$3 -N
}

# colouring ls
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ll='ls -alh'

# remove all pyc files in current dir
alias killpyc="find . -name '*.pyc' -delete"

# docker stuff
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/douglas/.docker/machine/machines/dev"
export DOCKER_MACHINE_NAME="dev"

export PYLINTRC=/Users/douglas/growthintel/gi_style_guides/style/pylintrc

export SPARK_HOME=/usr/local/Cellar/apache-spark131/1.3.1/libexec
