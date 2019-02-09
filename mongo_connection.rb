require 'mongo'

def connect_to_mongo
  client = Mongo::Client.new([ ENV['MONGO_HOST'] ], :database => ENV['MARVEL_DATABASE'])
  client[ENV['MARVEL_COLLECTION'].to_sym]
end
