require 'json'
require 'digest'
require 'net/http'

require_relative 'mongo_connection'
require_relative 'models/character'

ts = '10'
private_key = ENV['MARVEL_PRIVATE_KEY']
public_key  = ENV['MARVEL_PUBLIC_KEY']

def request_hash(ts, private_key, public_key)
  Digest::MD5.hexdigest ts + private_key + public_key
end

def parameters(ts, private_key, public_key)
  {
    :ts => 10,
    :limit => 100,
    :hash => request_hash(ts, private_key, public_key),
    :apikey => public_key
  }
end

def insert_heroes(ts, private_key, public_key)
  collection = connect_to_mongo

  uri       = URI('https://gateway.marvel.com/v1/public/characters')
  uri.query = URI.encode_www_form(parameters(ts, private_key, public_key))
  response  = Net::HTTP.get_response(uri)

  begin
    if response.is_a?(Net::HTTPSuccess)
      results = JSON.parse(response.body)['data']['results']

      results.each do |hero|
        character = Character.new().from_json(hero.to_json)
        collection.insert_one(character.to_json)
      end
    end

  rescue Exception => e
    puts e.message
  end
end

insert_heroes(ts, private_key, public_key)
