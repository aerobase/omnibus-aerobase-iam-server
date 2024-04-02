#!/bin/bash

# Debian & Ubuntu are ignoring .bashrc file
# Export all path variables manually.

# Maven 
export M2_HOME=/usr/local/maven
export M2="$M2_HOME/bin"
PATH="$M2:$PATH"

# Ruby 
export PATH="/var/lib/jenkins/.rbenv/bin:$PATH"
eval "$(/var/lib/jenkins/.rbenv/bin/rbenv init -)"
export PATH="/var/lib/jenkins/.rbenv/plugins/ruby-build/bin:$PATH"

# Node JS
export NVM_DIR="/var/lib/jenkins/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

rbenv global 2.7.2

ruby -v 
gem -v
mvn -v 
git --version

gem install bundler -v 2.3.18
gem install omnibus -v 9.0.24
gem install rack -v 3.0.8

bundle update
bundle config set --local without 'development'
bundle install --all

if [ "${CLEAN_CACHE}" == "true" ]; then
	bin/omnibus clean aerobase-iam --purge
fi

# Remove old packages 
rm -rf "${WORKSPACE}"/pkg/aerobase-iam*

# Build version
bundle exec omnibus build aerobase-iam
