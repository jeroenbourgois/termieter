# FUNCTIONS

echoo() {
  printf "\x1b[34;01m▽ %s\x1b[39;49;00m\n" $1
}

have() {
  type "$1" &> /dev/null
}

function fasterfaster() {
  sudo rm -rf /private/var/log/asl/*
  sudo rm -rf /var/mail/*
}

##########################################################

alias ls='ls $LS_OPT' # long list, excludes dot files
alias ll='ls $LS_OPT -GlhA' # long list all, includes dot files
alias l='ls $LS_OPT -1AFC'

if [[ $OS == 'OSX' ]]; then
  alias cat='ccat'
fi

alias termieter="cd $TRM"
alias termietere="cd $TRM; vim ."

alias vimd="cd ~/.vim"
alias vime="cd ~/.vim; vim ."

alias v='vim .'
alias vi='vim'

alias va='vagrant'
alias be='bundle exec'

alias ping='echoo "ping -c 5"; ping -c 5' # ping 5 times ‘by default’

alias hosts='sudo vim /etc/hosts'

if [ -d $DROPBOX ]; then
  alias work="cd $DROPBOX/Work/"
  alias archive="cd $DROPBOX/Work/archive/"
  alias repos="cd $DROPBOX/Work/repos/"
  alias jackjoe="cd $DROPBOX/Work/jackjoe/"
  alias dev="cd $DROPBOX/Work/devel/"
fi

function randcolor() {
  colors=("DarkSlateGray" "Green" "MediumPurple" "OliveDrab" "DeekSkyBlue")

  RANDOM=$$$(date +%s)
  selectedColor=${colors[$RANDOM % ${#colors[@]} ]}

  echoo "wasko -p $selectedColor"

  wasko -p $selectedColor
}

##########################################################

if [[ $OS == 'OSX' ]]; then
  alias cwd='echoo "pwd | pbcopy"; pwd | pbcopy'

  alias projects="cd ~/Documents/Projects/"

  alias mutt='cd ~/Downloads && mutt'

  # Spotlight
  alias spotlight-stop='sudo mdutil -i off /'
  alias spotlight-clear='sudo mdutil -E /'
  alias spotlight-start='sudo mdutil -i on /'

  # Sleepimage
  alias sleepimage-clear='sudo rm /private/var/vm/sleepimage'

  # function fix-fonts() {
  #   echoo "atsutil databases -removeUser; atsutil server -shutdown; atsutil server -ping"
  #
  #   atsutil databases -removeUser
  #   atsutil server -shutdown
  #   atsutil server -ping
  # }

  # MYSQL
  alias mysql-start='launchctl load /usr/local/Cellar/mysql/5.6.24/homebrew.mxcl.mysql.plist'
  alias mysql-stop='launchctl unload /usr/local/Cellar/mysql/5.6.24/homebrew.mxcl.mysql.plist'
  alias mysql-restart='mysql-stop | mysql-start'

  # POSTGRESQL
  # alias postgresql-start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
  # alias postgresql-stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
  # alias posgresql-restart='postgresql-stop | postgresql-start'

  # APACHE
  alias apache-start='sudo apachectl start'
  alias apache-restart='sudo apachectl restart'
  alias apache-stop='sudo apachectl stop'

  alias apache-vhosts='sudo vim /private/etc/apache2/extra/httpd-vhosts.conf'
  alias apache-config='sudo vim /private/etc/apache2/httpd.conf'
else
  function list-services() {
    chkconfig --list | grep '3:on'
  }

  function active-connections() {
    netstat -tulpn
  }
fi

##########################################################

# SVN
export SVN_EDITOR='vim'

alias svns='svn st'
alias svnc='svn commit -m "$@"'
alias svnu='svn up'

svn-add-all() {
  svn st | grep "^?" | awk '{$1=""; print $0}' | while read f; do svn add "$f"; done
}

svn-delete-all() {
  svn st | grep '^\!' | sed 's/! *//' | xargs -I% svn rm %
}

alias svn-status-all="$FT/svnstatus.py $@"
alias svn-up-all="$FT/functions/svnup.py $@"
alias svn-update-all='svn-up-all'

##########################################################

# GIT
alias gsync='echoo "git stash"; echoo "git pull"; echoo "git stash pop"; git stash && git pull && git stash pop'

gpp() {
  # Grunt
  if have grunt; then
    local gruntout="`grunt`";

    if [[ ! $gruntout =~ .*Unable\ to\ find\ local\ grunt.* ]]; then
      echoo "grunt production";

      grunt production;

      echoo "git add .; git commit;";

      git add .;
      gc -m 'grunt production';
    fi
  fi

  # Git
  echoo "git commit --allow-empty -m [deploy: production]; git push";

  git commit --allow-empty -m "[deploy: production]";
  git push
}

alias glod='gl origin develop'
alias glom='gl origin master'
# alias gcm='gc -m $@'

function gcmm() {
  gc -m "$*"
}

function gcm() {
  gc -m "$*"
}

git-status-all() {
  for gitdir in `find . -name .git`;
  do
    local workdir=$(dirname $gitdir);
    local gitout="`git -c color.status=always --git-dir=$gitdir --work-tree=$workdir status`";

    if [[ ! $gitout =~ .*nothing\ to\ commit,\ working\ directory\ clean.* ]];
    then
      echo;
      echo $workdir;
      echo $gitout;
      echo "###########################################";
    fi
  done
}

##########################################################

# TMUX
alias t='tmux'
alias tk='tmux kill-server'
alias ta='tmux attach-session -t $@'
alias tl='tmux ls'

test "$(uname -s)" = "Darwin" && tmux_wrapper=reattach-to-user-namespace

function tt-mail() {
  tmux has-session -t mutt 2>/dev/null

  if [ "$?" -eq 1 ] ; then
    tmux new-session -d -s "mutt" "$tmux_wrapper -l $SHELL"
  fi
}

function tt() {
  # tt-mail

  # var for session name (to avoid repeated occurences)
  sn=`echo ${PWD##*/}`

  # This will also be the default cwd for new windows created
  # tmux new-session -d -s "$sn" "$tmux_wrapper vim ."
  tmux new-session -d -s "$sn" "$tmux_wrapper -l $SHELL"

  # New window
  tmux new-window -t "$sn:2" "$tmux_wrapper -l $SHELL"

  # Select window #1 and attach to the session
  tmux select-window -t "$sn:1"
  tmux -2 attach-session -t "$sn"
}

# for tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color

##########################################################

# RBENV
if have rbenv; then
  eval "$(rbenv init -)"
else
  if [ -s "~/.rbenv/bin" ]; then
    export PATH="~/.rbenv/bin:$PATH"

    eval "$(rbenv init -)"
  elif [ -s "/usr/local/rbenv/bin" ]; then
    export PATH="/usr/local/rbenv/bin:$PATH"

    eval "$(rbenv init -)"
  fi
fi

##########################################################

# GO
if [[ $OS == 'OSX' ]]; then
  export GOPATH="$DROPBOX/Work/go"
  export GOROOT="/usr/local/go"
else
  export GOROOT="/usr/lib/go"
  export GOPATH="$HOME/go"
fi

export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

alias godir="cd $GOPATH"

##########################################################

# ANDROID
export PATH="$PATH:$DROPBOX/Work/devel/Android/sdk/platform-tools"
export PATH="$PATH:$DROPBOX/Work/devel/Android/sdk/tools"

##########################################################

# GRUNT
if have grunt; then
  eval "$(grunt --completion=zsh)"
fi

##########################################################

# HASKELL
export PATH="$PATH:$HOME/.cabal/bin"

##########################################################
