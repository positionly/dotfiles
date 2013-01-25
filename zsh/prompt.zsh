autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git=$commands[git]
else
  git=/usr/bin/git
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo " %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo " %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
  ref=$($git symbolic-ref HEAD 2>/dev/null) || return
  echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo "%{$fg[green]%}✔%{$reset_color%}"
  else
    echo "%{$fg[red]%}✗%{$reset_color%}"
  fi
}

rb_prompt(){
  if (( $+commands[rbenv] ))
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
export PROMPT=$'\n%{$fg[white]%}$(whoami): $(directory_name)%{$reset_color%}$(git_dirty)%{$fg[yellow]%}%(!.#. ›)%{$reset_color%} '
export RPROMPT="$(rb_prompt)"

precmd() {
  title "zsh" "%m" "%55<...<%~"
}
