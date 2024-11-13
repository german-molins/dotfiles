#################################################
# Generic aliases
#################################################

alias la='ls -A --color=auto --group-directories-first'
alias ll='ls -lh --color=auto --file-type --group-directories-first'
alias lla='ls -Alh --color=auto --file-type --group-directories-first'
alias lc='ls -1 --color=auto --file-type --group-directories-first'
alias lca='ls -1A --color=auto --file-type --group-directories-first'
alias lcc='ls -C --color=auto --file-type --group-directories-first'
alias lcca='ls -CA --color=auto --file-type --group-directories-first'
alias lu='du -sh * | sort -hr | less -FX'

alias c=clear
alias c,=c\;p
alias c.=c\;p.
alias cf=cfiles
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
alias zippdf="find -type f -iname '*.pdf' -exec gzip -vf {} +"

# Creates aliases for additional chezmoi source directories
# For each directory matching ~/.local/share/chezmoi_*, creates
# an alias chezmoi-name that uses that directory as source
# Example: ~/.local/share/chezmoi_work creates alias chezmoi-work
for source_dir in ~/.local/share/chezmoi_*; do
    if [ -d "$source_dir" ]; then
        name=${source_dir##*/chezmoi_}
        alias "chezmoi-${name}"="chezmoi --source ${source_dir}"
    fi
done
