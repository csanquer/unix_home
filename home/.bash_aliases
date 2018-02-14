#!/bin/sh
alias bc='bc -l'
alias vi='vim'
alias lessvim='/usr/share/vim/vim73/macros/less.sh'
alias suvi='sudo vim'
alias emacs='emacs -nw'
alias suemacs='sudo emacs -nw'
alias ls='ls --color=auto'
alias l='ls'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias la='ls -ah'
alias lr='ll -R'
alias ll='ls -lha'
alias lt='lstree'
alias lat='lsatree'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ack='ack-grep'
alias ackp='ack-grep --nocolor --pager="less -r"'
alias csvn='colorsvn'
alias svni='svn --ignore-externals'
alias csvni='csvn --ignore-externals'
alias svnvimdiff='svn diff --diff-cmd ~/bin/diffwrap.sh'
alias svnvimmerge='svn merge --diff3-cmd  ~/bin/diff3wrap.sh'
alias findsvn='find . -type d -name .svn'
alias findtilde='find . -name "*~"'
alias findcrlf='find . -not -type d -exec file "{}" ";" | grep CRLF'
alias findmac='find . \( -type d -name "__MACOSX" \) -o \( -type f -name ".DS_Store" \)'
alias rmt='trash-put'
alias rmmac='rm -rf `find . \( -type d -name "__MACOSX" \) -o \( -type f -name ".DS_Store" \)`'
alias rmsvn='rm -rf `find . -type d -name .svn`'
alias rmtilde='rm -f `find . -name "*~"`'
alias rmkeepsvn='rm -rf `find . -not \( -name '.svn' -type d -prune \) -type f `'
alias rmgit='rm -rf `find . -type d -name .git`'
alias rmkeepgit='rm -rf `find . -not \( -name '.git' -type d -prune \) -type f `'
alias findtextfiles='find . -type f \! -regex ".*\.\(jpg\|ico\|bmp\|jpeg\|png\|svg\|psd\|swf\|z\|tar\|zip\|bz2\|7z\|gz\|tgz\|phar\|jar\)" \! -path "*svn*" \! -path "*.git/*"'
#alias fromdos='dos2unix'
#alias todos='unix2dos'
alias fromdosr='find . -type f \! -regex ".*\.\(jpg\|ico\|bmp\|jpeg\|png\|svg\|psd\|swf\|z\|tar\|zip\|bz2\|7z\|gz\|tgz\|phar\|jar\)" \! -path "*svn*" \! -path "*.git/*" -exec fromdos {} \;'
alias todosr='find . -type f \! -regex ".*\.\(jpg\|ico\|bmp\|jpeg\|png\|svg\|psd\|swf\|z\|tar\|zip\|bz2\|7z\|gz\|tgz\|phar\|jar\)" \! -path "*svn*" \! -path "*.git/*" -exec todos {} \;'
alias screen='screen -'
alias sc='screen'
alias scc='screen -S charlie'
alias scdr='screen -dR '
alias scls='screen -ls'
alias tm='tmux'
alias tmls='tmux ls'
alias tman='if tmux has; then tmux attach -d; else tmux new; fi'
alias clr='clear'
alias du='du -h'
alias dus='du -s'
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'''
alias dufr='du -sk * | sort -nr | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'''
alias df='df -hT --total'
#alias wanip='curl http://www.whatismyip.org/; echo "";'
alias wanhost='curl ifconfig.me/host'
alias wanhost2='wget -q -O- ifconfig.me/host'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias wanip2="dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '\"' "
alias php-cs='php-cs-fixer'
alias php-cs-fix='php-cs-fixer fix .'
alias composer='php -d apc.enable_cli=0 /usr/local/bin/composer'
alias cmpsr='composer'
alias cmpsrin='cmpsr install --prefer-source'
alias cmpsrup='cmpsr update --prefer-source'
alias setsf2acl='sudo setfacl -R -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs; sudo setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs'
alias setsf2aclmacosx='rm -rf app/cache/*;rm -rf app/logs/*;sudo chmod +a "_www allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs;sudo chmod +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs'
alias phpnoapc='php -d apc.enable_cli=0'
alias pip2upgrade="sudo pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1  | sudo xargs pip2 install -U"
alias pip3upgrade="sudo pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | sudo xargs pip3 install -U"

#binaries
alias dk='docker'
alias dkc='docker-compose'
alias dkm='docker-machine'

# docker
# Get latest container ID
alias dkl="docker ps -l -q"
# Get container process
alias dkps="docker ps"
# Get process included stop container
alias dkpa="docker ps -a"
# Get images
alias dkim="docker images"
# Get container IP
alias dkip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
# Run deamonized container, e.g.: dkd base /bin/echo hello
alias dkd="docker run -d -P"
# Run interactive container, e.g.: dki base /bin/bash
alias dki="docker run -it -P"
# Run interactive container and delete on exit, e.g.: dkir base /bin/bash
alias dkir="docker run --rm -it -P"
# Execute interactive container, e.g.: dkex base /bin/bash
alias dkex="docker exec -it"
# Stop all containers
alias dkstop='docker stop $(docker ps -a -q)'
# Remove all containers
alias dkrm='docker rm $(docker ps -a -q)'
# Stop and Remove all containers
alias dkrmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
# To delete all exited containers
alias dkrmexit='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'
# to delete all orphaned (untagged) images (and save disk space)
alias dkrmorph='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
# to delete all unused automatic volumes (and save disk space)
alias dkrmvol='docker volume rm $(docker volume ls -q --filter "dangling=true")'
# Remove all images
# alias dkri='docker rmi $(docker images -q)'
# Dockerfile build, e.g.: dbu tcnksm/test
dkbu() { docker build -t=$1 .; }
# Show all alias related docker
dkalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }
# Bash into running container
dkbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

#docker-compose logs
alias dkcl="docker-compose logs -f -t"
