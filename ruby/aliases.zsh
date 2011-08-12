alias f='RAILS_ENV=fi'

alias rg='bundle exec rails generate'
alias rsv='bundle exec rails server -p `available_rails_port`'
alias rc='bundle exec rails console'

alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'

alias migrate='rake db:migrate db:test:clone'

alias s="ps aux | grep \"[s]cript/rails\" || echo \"You're not running any, dawg.\""

alias watch="watchr ~/.watchr/rails.rb"
