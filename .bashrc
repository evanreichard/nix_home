# ALIASES
alias cgrep="grep --color"
alias vim="/Applications/MacVim.app/Contents/bin/mvim -v"
alias utcclock="TZ=UTC vtclock"
alias urldecode='python -c "import sys, urllib as ul; \
  print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; \
  print ul.quote_plus(sys.argv[1])"'

# FUNCTIONS
function sfind(){
    find . -name "$1" -print0 | xargs -0 grep "$2"
}

function csv2mdt(){
    cat $1 | sed 1p | LC_ALL=C sed -e 's/,/ |\&nbsp\;\&nbsp\; /g' -e 's/^/| /g' -e 's/$/ |/g' -e '2 s/[^|]/-/g' | LC_ALL=C tr -d $'\r'
}

# EXPORTS
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PS1="\[\e[00;31m\][\h]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;32m\]\u\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;34m\][\w]\[\e[0m\]\[\e[00;37m\]\n [\#] \\$ \[\e[0m\]"
[ ! -z $TMUX ] || tmux a || tmux
neofetch
