class Graylog2Server < FPM::Cookery::Recipe
  homepage    'http://graylog2.org'
  name        'graylog2-server'
  version     '0.10.0'
  source      "http://download.graylog2.org/#{name}/#{name}-#{version}.tar.gz"
  md5         '7f02dc4ca30dd79289c95c42e248ea12'

  revision    '2'
  vendor      'aussielunix'
  maintainer  'Mick Pollard <aussielunix@gmail.com>'
  license     'GPL-3'
  description 'graylog2-server is the server part of an open source log management solution that stores your logs in elasticsearch.'
  arch	      'amd64'
  section     'admin'

  depends     'java-runtime-headless'

  config_files '/etc/graylog2.conf elasticsearch.yml.example'

  def build
    inline_replace 'bin/graylog2ctl' do |s|
      s.gsub! 'GRAYLOG2_SERVER_JAR=graylog2-server.jar', 'GRAYLOG2_SERVER_JAR=' + share('graylog2-server/graylog2-server.jar')
      s.gsub! 'LOG_FILE=log/graylog2-server.log', 'LOG_FILE=' + var('log/graylog2-server.log')
    end

    inline_replace 'graylog2.conf.example' do |s|
      s.gsub! 'mongodb_useauth = true', 'mongodb_useauth = false'
      s.gsub! 'mongodb_host = localhost', 'mongodb_host = 127.0.0.1'
    end
  end

  def install
    bin.install 'bin/graylog2ctl'
    etc('init').install_p workdir('graylog2-server.upstart'), 'graylog2-server.conf'
    etc.install_p 'graylog2.conf.example', 'graylog2.conf'
    etc.install_p 'elasticsearch.yml.example', 'graylog2-elasticsearch.yml'
    share('graylog2-server').install workdir('COPYING')
    share('graylog2-server').install workdir('README')
    share('graylog2-server').install 'build_date'
    share('graylog2-server').install 'graylog2-server.jar'
  end
end
