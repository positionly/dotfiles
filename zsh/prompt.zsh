autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_branch() {
  echo $(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$(git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo " "
  else
    if [[ $st == "nothing to commit (working directory clean)" ]]
    then
      echo " %{$fg[green]%}[$(git_prompt_info):%{$reset_color%} $(need_push)%{$fg[green]%}]%{$reset_color%} "
    else
      echo " %{$fg[red]%}[$(git_prompt_info):%{$reset_color%} $(need_push)%{$fg[red]%}]%{$reset_color%} "
    fi
  fi
}

git_prompt_info () {
 ref=$(git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

project_name () {
  name=$(pwd | awk -F'Development/' '{print $2}' | awk -F/ '{print $1}')
  echo $name
}

unpushed () {
  git cherry -v origin/$(git_branch) 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo "%{$fg[green]%}✔%{$reset_color%}"
  else
    echo "%{$fg[red]%}✗%{$reset_color%}"
  fi
}

rbenv_prompt(){
  if $(which rbenv &> /dev/null)
  then
    echo "%{$fg_bold[blue]%}ruby $(rbenv version-name)%{$reset_color%}"
  else
    echo ""
  fi
}


directory_name(){
  echo "%{$fg[blue]%}%1/%\/%{$reset_color%}"
}

#export PROMPT=$'\n%{$fg[white]%}$(whoami)@$(networksetup -getcomputername)%{$reset_color%}$(git_dirty)in $(directory_name) \n %{$fg[yellow]%}%(!.#.⚡)%{$reset_color%} '
export PROMPT=$'\n%{$fg[white]%}$(whoami): $(directory_name)%{$reset_color%}$(git_dirty)%{$fg[yellow]%}%(!.#.⚡)%{$reset_color%} '
export RPROMPT="$(rbenv_prompt)"

precmd() {
  title "zsh" "%m" "%55<...<%~"
}

# Colorize stderr red
# exec 2>>(while read line; do print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)
