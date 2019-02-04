require 'net/http'
require 'digest'

ts = '10'
private_key = 'fb61d476652652df4f0ba4cc87c064cb4f571104'
public_key = '1cc3273da2db902ff9c8dc5d210d16f8'

request_hash = Digest::MD5.hexdigest ts + private_key + public_key

uri = URI('https://gateway.marvel.com/v1/public/characters')
parameters = { :ts => 10, :apikey => public_key, :hash => request_hash }
uri.query = URI.encode_www_form(parameters)

response = Net::HTTP.get_response(uri)
puts response.body if response.is_a?(Net::HTTPSuccess)
