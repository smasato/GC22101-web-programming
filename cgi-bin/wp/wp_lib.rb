# frozen_string_literal: true

require 'uri'
require 'date'
require 'csv'
require 'yaml'

CONFIG = File.expand_path('config.yaml', __dir__)

def fetch_config
  YAML.load_file(CONFIG)
end

def local?
  File.file?(File.expand_path('.local', __dir__))
end

def url(path)
  config = fetch_config
  URI.join(config[local? ? 'local' : 'tsukuba']['base_url'], path)
end

def get_filepath(file)
  config = fetch_config

  if local?
    File.join(File.dirname(file), File.basename(file, '.*') + config['local']['suffix'] + File.extname(file))
  else
    file
  end
end
