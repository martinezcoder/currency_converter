require 'singleton'
require 'erb'

class ExchangeRateConverter
  class Config
    include Singleton

    def config_dir
      File.expand_path('../../config', __dir__)
    end

    def db_dir
      File.expand_path('../../db', __dir__)
    end

    def db_migrations_dir
      File.join(db_dir, 'migrate')
    end

    def db
      @db ||= load_yaml('database.yml')
    end

    def db_current
      db.fetch(ExchangeRateConverter.env)
    end

    protected

    def load_yaml(filename)
      file = File.read(File.join(config_dir, filename))
      compiled_file = ERB.new(file).result
      YAML.load(compiled_file)
    end
  end
end
