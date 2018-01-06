export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

cd $1 

ruby monitor.rb
