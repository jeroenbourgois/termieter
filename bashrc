# Global settings for Terminal environment

if [[ `uname` == 'Darwin' ]]; then
	export LS_OPT=''
elif [[ `uname` == 'Linux' ]]; then
	export LS_OPT='--color=auto'
fi

# HISTORY
######################################################################################################

export HISTCONTROL=erasedups # Erase duplicates
export HISTCONTROL=ignoreboth # Ignore same sucessive entries.
export HISTSIZE=6000 # resize history size

shopt -s histappend # append to bash_history if Terminal.app quits

# ALIASES
######################################################################################################

if [[ `uname` == 'Darwin' ]]; then
  export EDITOR='mate -w'
elif [[ `uname` == 'Linux' ]]; then
  export EDITOR='vim'
fi

alias ..='cd ..'
alias ...='cd .. ; cd ..'

alias ls='ls $LS_OPT -Gl' # long list, excludes dot files
alias ll='ls $LS_OPT -Gla' # long list all, includes dot files

alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'" # Get readable list of network IPs
alias ip='dig +short myip.opendns.com @resolver1.opendns.com' # my ip
alias flushdns='dscacheutil -flushcache' # Flush DNS cache

alias gzip='gzip -9n' # set strongest compression level as ‘default’ for gzip
alias ping='ping -c 5' # ping 5 times ‘by default’

alias hidden-show='defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder'
alias hidden-hide='defaults write com.apple.finder AppleShowAllFiles -bool false; killall Finder'

alias cwd='pwd | pbcopy' # copy current working directory to clipboard

alias hosts='mate /private/etc/hosts'

alias fasterfaster='sudo rm -f /private/var/log/asl/*'

alias hist='history | grep "$@"'
alias hist-sort='history | cut -c 8- | sort | uniq -c | sort -rn'

# COLORS + PROMPT
######################################################################################################

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

WHITE="\[\033[1;37m\]"
LIGHT_BLUE="\[\033[1;36m\]"
BLUE="\[\033[1;34m\]"
LIGHT_RED="\[\033[1;31m\]"
RED="\[\033[0;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
GREEN="\[\033[0;32m\]"

PROMPT_COMMAND='DIR=`pwd|sed -e "s!$HOME!~!"`; if [ ${#DIR} -gt 34 ]; then CurDir=${DIR:0:14}...${DIR:${#DIR}-17}; else CurDir=$DIR; fi'

PS1="[$LIGHT_RED\u:\$CurDir:$LIGHT_BLUE\$(parse_git_branch)$LIGHT_BLUE$WHITE]\\$  "

# SPECIAL FUNCTIONS
######################################################################################################


