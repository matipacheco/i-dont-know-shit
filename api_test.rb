require 'json'
require 'digest'
require 'net/http'

require_relative 'models/character'

def load_fighters
  File.foreach('characters_id.txt') do |line|
    fighter_1, fighter_2 = line.split(',').sample(2)
    return [fighter_1, fighter_2]
  end
end

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

fighters = []

load_fighters.each do |fighter|
  uri       = URI('https://gateway.marvel.com/v1/public/characters/' + fighter)
  uri.query = URI.encode_www_form(parameters(ts, private_key, public_key))
  response  = Net::HTTP.get_response(uri)

  if response.is_a?(Net::HTTPSuccess)
    result = JSON.parse(response.body)['data']['results']
    puts result

    character = Character.new()
    fighters << character.from_json(result.to_json)

  else
    raise "API conection error!"
  end
end

fighter_1, fighter_2 = fighters

puts 'Los luchadores son: ' + fighter_1.name.to_s + ' y ' + fighter_2.name.to_s
