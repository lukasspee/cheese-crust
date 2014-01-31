require "bundler/setup"
require "sinatra"
require "dm-core"
require "dm-migrations"
require "csv"

DataMapper.setup(:default, "sqlite3:data.db")

class Cheese
  include DataMapper::Resource

  property :id,     Serial
  property :name,   String, required: true
  property :edible, Boolean, required: true
end

DataMapper.finalize
DataMapper.auto_upgrade!

CSV.foreach(File.join(__dir__, "data.csv")) do |line|
  name   = line[0]
  edible = line[1]

  Cheese.first_or_create({ name: name }, { edible: (edible == "true") })
end

get "/" do
  haml :index
end

post "/" do
  query  = "%#{params[:query]}%"
  results = Cheese.all(:name.like => query)

  haml :results, locals: { results: results }
end
