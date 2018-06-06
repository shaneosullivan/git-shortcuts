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

# 'git add' the next modified file
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
# will call 'git add ....../Button.js' for every occurrance
function gal {
  if [ -z "$1" ]
    then
      echo "No file name supplied.  You must provide a file name to be extracted from 'git status' and be passed to 'git add'"
    else
      gs | grep "$1" | sed 's/modified://g' | sed 's/         //g' | xargs -n 1 -P 1 -I {} bash -c 'ga "$@"' _ {}
  fi
}

# Open the last modified file with vi for editing
function vil {
  vi $(get_last)
}
