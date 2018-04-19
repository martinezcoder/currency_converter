## Exchange Rate Converter

### Setup the environment

Run `sh bin/setup.sh` or execute the next commands:

```
$ sh bin/setup.sh
```

or

```
$ bundle
$ rm db/data.sqlite3
$ bundle exec rake db:create db:migrate
$ bundle exec rake db:test:prepare
$ chmod 755 bin/*
```

### Run the tests

```
$ bundle exec rspec spec
```

### Load the data

```
$ bin/download
```

### Run conversions

```
$ bin/converter 120 '2011-03-05'
167.52
```

### Examples with errors

```
> bin/converter hola '2015-01-20'
invalid value for Float(): "hola"
```

```
> bin/converter 120 '20-03-05'
Date must have the format 'YYYY-MM-DD'
```

## Notes

The code of the test is in the **lib** folder.
The code to download the data is on **lib/services/** folder.

### About the config

This code uses ActiveRecord and SQLite database. However, I used the power of
active_record to make it easy to swap to Postgres, Mysql or whatever, just
as you would do it in Rails: configuring the `database.yml` file.

The URL with the path for the CSV file is in the `database.yml` as well. I
would use a `config.yml` file, but I didn't do it to not include too many
stuff about configuration.


### About amounts and dates

I decided not to deal too much with floats, decimals and dates, so I am persisting the dates and the values as
integers (**don't panic, I mean integers with decimals**).

Using enough decimals to convert a float to integer, it makes the value management a lot easier. You can see this in the
helpers.

### About getting the previous date

I was thinking in diferent ways to do so, but I think what I have use is clear
enough. Find this in the scope of the model definition.

Also, the databse has an **index** in the date column, to make the search faster.
