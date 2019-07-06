# If you come from bash you might have to change your $PATH.
# /usr/local/opt/python/libexec/bin:$PATH export GOROOT=/usr/local/Cellar/go/1.11.2/libexec
#
export GOPATH="/Users/eq/Documents/go"
export PATH="/usr/local/sbin:$PATH:$GOPATH/bin"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/lib/python3.7/site-packages:$PATH"
# maven path
export PATH="$PATH:/usr/local/opt/apache-maven/bin"
#export PATH="/Users/eq/Library/Python/3.7/bin:$PATH"
#export PATH="$HOME/.cargo/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/Users/eq/.oh-my-zsh
export ZPLUG_HOME=/usr/local/opt/zplug
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1
export EDITOR=nvim
#
# # Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color
#export TERM=tmux-256color
# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git, rails, ruby, osx, kubectl)

source $ZSH/oh-my-zsh.sh
source /Users/eq/.aliases.sh
source $ZPLUG_HOME/init.zsh
# init gruvbox
# source /Users/eq/Documents/others/gruvbox/gruvbox_256palette_osx.sh
#source ~/.bin/tmuxinator.bash
# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#DOCKER_MACHINE="master"
#if docker-machine status $DOCKER_MACHINE | grep "Running" &> /dev/null
# then
#   eval "$(docker-machine env $DOCKER_MACHINE)"
# else
#   docker-machine start $DOCKER_MACHINE && eval "$(docker-machine env $DOCKER_MACHINE)"
#fi

#zplug "b4b4r07/enhancd", use:init.sh
#if ! zplug check; then
#    zplug install
#fi
#
#if zplug check b4b4r07/enhancd; then
#    # setting if enhancd is available
#    export ENHANCD_FILTER=fzf
#fi
#
#zplug load
#
#eval docker everytime bash is opened
eval $(docker-machine env)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

f() {
  local cols sep
  columns=$(( COLUMNS / 3 ))
  separator='{::}'
  sqlite3 -separator $separator $HOME/Library/Safari/History.db \
          "select distinct substr(title, 1, $columns), url from history_items
           inner join history_visits on history_items.id = history_visits.history_item
           order by history_visits.visit_time desc;" |
  awk -F $separator '{printf "%-'$columns's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}

c() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

### fzh Function
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}
# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
                FZF-EOF"
}

# sleep-in - schedule sleep for macbook in minute
sleep-in() {
  local minutes=$1
  local datetime=`date -v+${minutes}M +"%m/%d/%y %H:%M:%S"`
  sudo pmset schedule sleep "$datetime"
}
fpath=(/usr/local/share/zsh-completions $fpath)

# export wakatime API key for wakawaka
export WAKATIME_API_KEY="71ad09db-a712-442a-ac64-2a55d8c20cad"
##autoload -U promptinit; promptinit
##prompt pure
#export PATH="/usr/local/opt/node@8/bin:$PATH"
#
#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
#
#export PATH="/usr/local/opt/openssl/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

  # Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt pure
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
#_comp_options="${_comp_options/NO_warnnestedvar/}"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
source ~/.rvm/scripts/rvm
