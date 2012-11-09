require 'toto'
require 'rack/rewrite'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger
use Rack::Deflater

use Rack::Rewrite do
  r301 /.*/,  Proc.new {|path, rack_env| "http://#{rack_env['SERVER_NAME'].gsub(/www\./i, '') }#{path}" },
    :if => Proc.new {|rack_env| rack_env['SERVER_NAME'] =~ /www\./i}
end

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end



#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  # 
   set :karakuri,  true
   set :author,    ENV['USER']                               # blog author
  # set :title,     Dir.pwd.split('/').last                   # site title
   set :title,      'Hugo Marinho'
  # set :root,      "index"                                   # page to load on /
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  # set :markdown,  :smart                                    # use markdown + smart-mode
  # set :disqus,    false                                     # disqus id, or false
   set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds

  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }

  set :to_html, lambda {|path, page, ctx|
    ERB.new(File.read("#{path}/#{page}.erb")).result(ctx)
  }
end

run toto


