require 'yaml'
require 'sinatra'
require 'appengine-apis/logger'
require 'appengine-apis/urlfetch'
Net::HTTP = AppEngine::URLFetch::HTTP

before do
  @config = YAML.load_file('config.yaml')
  unless params[:username] == @config['twitter']['username'] && params[:password] == @config['twitter']['password']
    logger.warn "unauthorized username=#{params[:username]}, password=#{params[:password]}"
    halt 401
  end
end

post '/image' do
  res = Net::HTTP.post_form(URI.parse('http://www.tumblr.com/api/write'),
                            {
                              'email'    => @config['tumblr']['email'],
                              'password' => @config['tumblr']['password'],
                              'type'     => 'photo',
                              'data'     => params[:media][:tempfile].read,
                              'caption'  => params[:message]
                            })
  if res.code == '201'
    [200, "<mediaurl>#{@config['tumblr']['baseurl']}/post/#{res.body}</mediaurl>"]
  else
    logger.warn "failure response_code=#{res.code}, response_body=#{res.body}"
    [res.code, res.body]
  end
end

def logger
  @logger ||= AppEngine::Logger.new
end
