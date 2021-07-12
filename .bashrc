if [ -e /Users/evanreichard/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/evanreichard/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# ------------------------------------------------------------------------------
# ---------------------------------- VI MODE -----------------------------------
# ------------------------------------------------------------------------------
set -o vi

# ------------------------------------------------------------------------------
# ---------------------------------- ALIASES -----------------------------------
# ------------------------------------------------------------------------------
alias vi="/Applications/MacVim.app/Contents/bin/mvim -v"
alias vim="/Applications/MacVim.app/Contents/bin/mvim -v"
alias grep="grep --color"

# Python URL Encode / Decoders
alias urldecode='python -c "import sys, urllib as ul; \
  print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; \
  print ul.quote_plus(sys.argv[1])"'

# Spin up a Docker container mounting hosts PWD to `/mount` in the container
alias fast_docker='docker run -ti -v $(pwd):/mount ubuntu /bin/bash'

# ------------------------------------------------------------------------------
# --------------------------------- FUNCTIONS ----------------------------------
# ------------------------------------------------------------------------------

function cache {
    # Description
    #   Caches the output and return of any command
    #
    # Usage:
    #   cache curl google.com
    #
    # Notes:
    #   Stores data in ~/.bash-cache/* - You need to manually clean up cache.

    cmd="$*"
    name=$(echo "$PWD-$cmd" | base64)
    if [[ -f ~/.bash-cache/$name.exit ]] && [[ $(cat ~/.bash-cache/$name.exit) -eq 0 ]]; then
        printf "CACHED:\n\n"
    else
        mkdir -p ~/.bash-cache
        eval "$cmd" > ~/.bash-cache/$name.out
        echo $? > ~/.bash-cache/$name.exit
    fi
    cat ~/.bash-cache/$name.out
}

function sfind(){
    # Description:
    #   Finds a file with name $1 and searches file using grep with $2
    #
    # Usage:
    #   sfind *.csv evan

    find . -name "$1" -print0 | xargs -0 grep "$2"
}

function csv2mdt(){
    # Description:
    #   Converts a CSV file to Markdown table format.
    #
    # Usage:
    #   To stdout:
    #       csv2mdt test.csv
    #   To clipboard:
    #       csv2mdt test.csv | pbcopy

    cat $1 | sed 1p | LC_ALL=C sed -e 's/,/ |\&nbsp\;\&nbsp\; /g' -e 's/^/| /g' -e 's/$/ |/g' -e '2 s/[^|]/-/g' | LC_ALL=C tr -d $'\r'
}

function ggrep(){
    # Description:
    #   Use grep to search through all git history. Search results return file and
    #   git commit hash. Using git commit hash, you can view state of repo in
    #   GitHub: https://github.com/<USER_OR_ORG>/<REPO>/tree/<GIT_HASH>
    #
    # Usage:
    #   No Directory Specification
    #       ggrep -in get_config
    #   Specify Directory
    #       ggrep -in get_config -- /rules
    #
    # Notes:
    #   To see specific arguments allowed, see `man git-grep`

    GREP_ARGS=$(echo "$@" | sed "s/\(^.*\)--\(.*$\)/\1/")
    PATH_ARGS=$(echo "$@" | sed "s/\(^.*\)--\(.*$\)/\2/")

    if [[ "$@" == "$GREP_ARGS" ]]; then
        unset PATH_ARGS
    fi

    if [[ -n $PATH_ARGS ]]; then
        git rev-list --all -- $PATH_ARGS | xargs -J{} git grep $GREP_ARGS {} -- $PATH_ARGS
    else 
        git rev-list --all | xargs -J{} git grep $GREP_ARGS {}
    fi
}

# ------------------------------------------------------------------------------
# ---------------------------------- EXPORTS -----------------------------------
# ------------------------------------------------------------------------------
export PATH=$HOME/.local/bin:$HOME/.yarn/bin:$HOME/Development/Tools/flutter/bin:$PATH
export GOPATH=$HOME/go
export KUBE_EDITOR="/Applications/MacVim.app/Contents/bin/mvim -v"
export NIX_PYTHONPATH=$(python3 -c "import sys; print(sys.base_prefix)")

# ------------------------------------------------------------------------------
# --------------------------------- POWERLINE ----------------------------------
# ------------------------------------------------------------------------------
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. $HOME/.local/lib/python3.9/site-packages/powerline/bindings/bash/powerline.sh

# ------------------------------------------------------------------------------
# ------------------------------ TMUX & NEOFETCH -------------------------------
# ------------------------------------------------------------------------------
[ ! -z $TMUX ] || tmux a || tmux
neofetch
