# frozen_string_literal: true

require 'uri'
require 'yaml'

CONFIG = File.expand_path('config.yaml', __dir__)

def fetch_config
  YAML.load_file(CONFIG) if File.exist?(CONFIG)
end

# local?  ->  true or false
#
# Returns <code>true</code> if '.local' file exist,
# and <code>false</code>
# otherwise.
def local?
  File.file?(File.expand_path('.local', __dir__))
end

def url(path)
  config = fetch_config
  URI.join(config[local? ? 'local' : 'tsukuba']['base_url'], path)
end

# get_filepath( file )  ->  string
#
# Returns file path with suffix if local
#    get_filepath("testfile")   #=> 'testfile_local' if local?
#    get_filepath("testfile")   #=> 'testfile' unless local?
def get_filepath(file)
  config = fetch_config

  if local?
    File.join(File.dirname(file), File.basename(file, '.*') + config['local']['suffix'] + File.extname(file))
  else
    file
  end
end
