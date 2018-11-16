require 'net/http'
require 'Digest'
require 'uri'
require 'json'
require './keys.rb'

name1, name2, seed = nil

BASE_MARVEL_API_URI = 'http://gateway.marvel.com/v1/public/characters'

def get_characters
  
  uri = URI(BASE_MARVEL_API_URI)
  nonce=Time.now.to_s
  params = {
    :ts => nonce,
    :apikey => ENV['public_key'],
    :hash => Digest::MD5.new.update(
      nonce+ENV['private_key']+ENV['public_key']
     ),
    :limit => 100
  }
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  characters = JSON.parse(res.body)['data']['results']

  for character in characters do
  	puts character['name']
  end

end

puts "acceptable character names:"
get_characters

puts "First Superman Name"
name1 = gets

puts "Second Superman Name"
name2 = gets


seed=nil
while !seed.to_i.between?(1,9)
	puts "please submit a number between 1-9"
	seed = gets
end