# ------------------------------------------------------------------------------
# ---------------------------------- ALIASES -----------------------------------
# ------------------------------------------------------------------------------
alias grep="grep --color"
alias vim="/Applications/MacVim.app/Contents/bin/mvim -v"
alias vi="/Applications/MacVim.app/Contents/bin/mvim -v"
alias urldecode='python -c "import sys, urllib as ul; \
  print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; \
  print ul.quote_plus(sys.argv[1])"'

# ------------------------------------------------------------------------------
# --------------------------------- FUNCTIONS ----------------------------------
# ------------------------------------------------------------------------------
function cache {
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
    find . -name "$1" -print0 | xargs -0 grep "$2"
}
function phow(){
    curl https://cht.sh/$1/$2?Q
}
function csv2mdt(){
    cat $1 | sed 1p | LC_ALL=C sed -e 's/,/ |\&nbsp\;\&nbsp\; /g' -e 's/^/| /g' -e 's/$/ |/g' -e '2 s/[^|]/-/g' | LC_ALL=C tr -d $'\r'
}

# ------------------------------------------------------------------------------
# ---------------------------------- EXPORTS -----------------------------------
# ------------------------------------------------------------------------------
export PATH=$HOME/.local/bin:$HOME/Library/Python/3.7/bin:$HOME/Library/Python/2.7/bin:/opt/local/bin:/opt/local/sbin:$PATH
export TERM=xterm-256color
export KUBE_EDITOR="/Applications/MacVim.app/Contents/bin/mvim -v"

# ------------------------------------------------------------------------------
# --------------------------------- POWERLINE ----------------------------------
# ------------------------------------------------------------------------------
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /Users/evanreichard/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh

# ------------------------------------------------------------------------------
# ------------------------------ TMUX & NEOFETCH -------------------------------
# ------------------------------------------------------------------------------
[ ! -z $TMUX ] || tmux a || tmux
neofetch
