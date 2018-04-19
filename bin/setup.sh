bundle
rm db/data.sqlite3
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:test:prepare
chmod 755 bin/*
