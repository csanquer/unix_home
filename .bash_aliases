#!/bin/sh
alias vi='vim'
alias suvi='sudo vim'
alias emacs='emacs -nw'
alias suemacs='sudo emacs -nw'
alias ls='ls --color=auto'
alias l='ls'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -lh'
alias lr='ll -R'
alias la='ls -lha'
alias lar='la -R'
alias lt='lstree'
alias lat='lsatree'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ack='ack-grep'
alias ackp='ack-grep --nocolor --pager="less -r"'
alias screen='screen -'
alias csvn='colorsvn'
alias svni='svn --ignore-externals'
alias csvni='csvn --ignore-externals'
alias svnvimdiff='svn diff --diff-cmd ~/bin/diffwrap.sh'
alias svnvimmerge='svn merge --diff3-cmd  ~/bin/diff3wrap.sh'
alias findsvn='find . -type d -name .svn'
alias findmac='find . \( -type d -name "__MACOSX" \) -o \( -type f -name ".DS_Store" \)'
alias rmt='trash-put'
alias rmmac='rm -rf `find . \( -type d -name "__MACOSX" \) -o \( -type f -name ".DS_Store" \)`'
alias rmsvn='rm -rf `find . -type d -name .svn`'
alias rmkeepsvn='rm -rf `find . -not \( -name '.svn' -type d -prune \) -type f `'
alias rmgit='rm -rf `find . -type d -name .git`'
alias rmkeepgit='rm -rf `find . -not \( -name '.git' -type d -prune \) -type f `'
alias findtextfiles='find . -type f \! -regex ".*\.\(jpg\|ico\|bmp\|jpeg\|png\|svg\|psd\|swf\|z\|tar\|zip\|bz2\|7z\|gz\|tgz\|phar\|jar\)" \! -path "*svn*" \! -path "*.git/*"'
#alias fromdos='dos2unix'
#alias todos='unix2dos'
alias fromdosr='find . -type f \! -regex ".*\.\(jpg\|ico\|bmp\|jpeg\|png\|svg\|psd\|swf\|z\|tar\|zip\|bz2\|7z\|gz\|tgz\|phar\|jar\)" \! -path "*svn*" \! -path "*.git/*" -exec fromdos {} \;' 
alias todosr='find . -type f \! -regex ".*\.\(jpg\|ico\|bmp\|jpeg\|png\|svg\|psd\|swf\|z\|tar\|zip\|bz2\|7z\|gz\|tgz\|phar\|jar\)" \! -path "*svn*" \! -path "*.git/*" -exec todos {} \;' 
alias sc='screen'
alias scc='screen -S charlie'
alias scdr='screen -dR '
alias scls='screen -ls'
alias clr='clear'
alias du='du -h' 
alias dus='du -s' 
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'''
alias dufr='du -sk * | sort -nr | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'''
alias df='df -hT --total'
#alias wanip='curl http://www.whatismyip.org/; echo "";'
alias wanhost='curl ifconfig.me/host'
alias wanip='curl ifconfig.me/ip'

