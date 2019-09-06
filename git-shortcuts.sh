function get_last {
  git status | grep modified: | tail -n 1 | sed 's/modified://g' | sed 's/         //g'
}

# 'git status' shortcut
function gs {
  git status
}

# Git diff the next modified file, or of a provided path if it exists
function gd {
  if [ -z "$1" ]
    then
      git diff $(get_last)
    else
      git diff "$1"
  fi
}

# 'git add' the next modified file, or add the provided path if it exists
function ga {
  if [ -z "$1" ]
    then
      git add $(get_last)
    else
      git add "$1"
  fi
}

# Add all modified files with the name provided to the current commit, e.g.
#   gal Button.js
# will call 'git add ....../Button.js' for every occurrance.
# Another good use case is to add all image assets to the commit, `gal .png`
function gal {
  if [ -z "$1" ]
    then
      echo "No file name supplied.  You must provide a file name to be extracted from 'git status' and be passed to 'git add'"
    else
      gs | grep "$1" | sed 's/modified://g' | sed 's/         //g' | xargs -n 1 -P 1 -I {} bash -c 'git add "$@"' _ {}
  fi
}

# Git commit all files
function gca {
  if [ -z "$1" ]
    then
      echo "You must provide a message for `git commit -am`"
    else
      git commit -am "$1"
  fi
}

# Checkout a branch.  Default to checking out the master branch
function gco {
  if [ -z "$1" ]
    then
      git checkout master
    else
      git checkout "$1"
  fi
}

function gb {
  git branch
}

# Show all branches along with their last modified time
function gbt {
  git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) -  (%(color:green)%(committerdate:relative)%(color:reset))'
}


# Checkout a new branch.
function gcob {
  if [ -z "$1" ]
    then
      echo "You must provide a name for the new branch to be created"
    else
      git checkout -b "$1"
  fi
}

# Show the files that have changed in the current branch. By default
# compares vs master, pass the name of another branch to compare against
# that
function gdiffb {
  if [ -z "$1" ]
    then
      git diff --name-only master
    else
      git diff --name-only "$1"
  fi
}

# git push the current branch. e.g. if the current
# branch is called "foo", it will do "git push origin foo"
function gpb {
  gb | grep "*" | sed 's/* //g' | xargs git push origin
}

# Open the last modified file with vi for editing
function vil {
  vi $(get_last)
}

# Remove all local branches that have been merged remotely
function gclean {
  git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d
}
