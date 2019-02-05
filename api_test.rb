require 'json'
require 'digest'
require 'net/http'

require_relative 'models/character'

ts = '10'
marvel_private_key = ENV['MARVEL_PRIVATE_KEY']
marvel_public_key  = ENV['MARVEL_PUBLIC_KEY']

request_hash = Digest::MD5.hexdigest ts + marvel_private_key + marvel_public_key

parameters = { :ts => 10, :apikey => marvel_public_key, :hash => request_hash }

uri       = URI('https://gateway.marvel.com/v1/public/characters')
uri.query = URI.encode_www_form(parameters)

response = Net::HTTP.get_response(uri)

if response.is_a?(Net::HTTPSuccess)
  results = JSON.parse(response.body)['data']['results']

  characters = []

  results.each do |result|
    character = Character.new()
    characters << character.from_json(result.to_json)
  end

  puts characters
else
  raise "API conection error!"
end
