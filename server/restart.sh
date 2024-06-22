bundle install
bundle exec thin -p 8181 -R config.ru -C thin.yml start