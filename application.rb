require "bundler/setup"
require "sinatra"

get "/" do
  haml :index
end

post "/" do
  haml :results, locals: { query: params[:query] }
end
