# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="bira"
ZSH_THEME="steeef"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source $HOME/.bash_aliases

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

#my bash aliases
source $HOME/.bash_aliases

# Customize to your needs...
export PATH=$PATH:/home/csanquer/bin:/home/csanquer/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

turquoise="$fg_bold[cyan]"
orange="$fg_bold[yellow]"
purple="$fg_bold[magenta]"
hotpink="$fg_bold[red]"
limegreen="$fg_bold[green]"
black="$fg[black]"
blue="$fg_bold[blue]"
white="$fg[white]"

if [ `whoami` = root ]; then
    PROMPT=$'%{$hotpink%}%n%{$reset_color%} at %{$orange%}%m%{$reset_color%} in %{$limegreen%}%~%{$reset_color%} $vcs_info_msg_0_
$(virtualenv_info)$ '
else
    PROMPT=$'%{$blue%}%n%{$reset_color%} at %{$orange%}%m%{$reset_color%} in %{$limegreen%}%~%{$reset_color%} $vcs_info_msg_0_
$(virtualenv_info)$ '
fi

