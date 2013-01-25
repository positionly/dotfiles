
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# rehash shims
rbenv rehash 2>/dev/null

# shell thing
rbenv() {
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  shell)
    eval `rbenv "sh-$command" "$@"`;;
  *)
    command rbenv "$command" "$@";;
  esac
}
