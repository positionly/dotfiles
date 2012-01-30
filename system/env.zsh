export EDITOR='mate -w'

# Load environment variables from .env file if it exists
# in the current directory
function chpwd() {
  if [ -r $PWD/.env ]; then
    source $PWD/.env
  fi
}
