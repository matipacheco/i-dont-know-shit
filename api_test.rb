require 'json'
require 'digest'
require 'net/http'

require_relative 'models/battle'
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



def load_fighters
  File.foreach('characters_id.txt') do |line|
    fighter_1, fighter_2 = line.split(',').sample(2)
    return [fighter_1, fighter_2]
  end
end

fighters = []

load_fighters.each do |fighter|
  uri       = URI('https://gateway.marvel.com/v1/public/characters/' + fighter)
  uri.query = URI.encode_www_form(parameters(ts, private_key, public_key))
  response  = Net::HTTP.get_response(uri)

  if response.is_a?(Net::HTTPSuccess)
    result = JSON.parse(response.body)['data']['results'].first

    fighters << Character.new().from_json(result.to_json)

  else
    raise "API conection error!"
  end
end

battle = Battle.new(fighters.sort_by(&:dice_roll).reverse)
puts battle.game_over
