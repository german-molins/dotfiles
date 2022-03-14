#################################################
# Generic aliases
#################################################

alias la='ls, -A --group-directories-first'
alias ll='ls, -lh --file-type --group-directories-first'
alias lla='ls, -Alh --file-type --group-directories-first'
alias lc='ls, -1 --file-type --group-directories-first'
alias lca='ls, -1A --file-type --group-directories-first'
alias lcc='ls, -C --file-type --group-directories-first'
alias lcca='ls, -CA --file-type --group-directories-first'
alias lu='du -sh * | sort -hr | less -FX'

alias c=clear
alias c,=c\;p
alias c.=c\;p.
alias cn=count
alias d='date -u'
alias eg=egrep
alias f=find
alias h=head
alias j=jobs
alias k=kill
alias l=ll
alias p=pwd
alias p.='pwd | xargs basename'
alias p..='realpath .. | xargs basename'
alias t=tail
alias tf='tail -f'
alias tx=tmux
alias u='df -H "$HOME"'
alias wcl='wc -l'
alias wh=where

alias ,r='vim -R'
alias ,m='vim -m'
alias ,.='vim -M'
alias e=vim

alias ..l='..;lc'
alias jl='jupyter-lab --no-browser --ip=0.0.0.0'

# Random hex 32
alias rhex='openssl rand -hex 32| cut -c -7'
