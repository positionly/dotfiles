export EDITOR='mate -w'

# Load environment variables from .env file if it exists
# in the current directory
function load_local_env() {
  if [ -r $PWD/.env ]; then
    source $PWD/.env
  fi
}

# Register the function so it is called whenever the working
# directory changes.
autoload add-zsh-hook
add-zsh-hook chpwd load_local_env
