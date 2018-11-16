require 'net/http'
require 'Digest'
require 'uri'
require 'json'
require './keys.rb'

BASE_MARVEL_API_URI = 'http://gateway.marvel.com/v1/public/characters'

@all_characters = []

def get_all_characters (offset)
  
  uri = URI(BASE_MARVEL_API_URI)
  nonce = Time.now.to_s
  params = {
    :ts => nonce,
    :apikey => ENV['public_key'],
    :hash => Digest::MD5.new.update(
      nonce+ENV['private_key']+ENV['public_key']
     ),
    :limit => 100,
    :offset => offset
  }
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  characters = JSON.parse(res.body)['data']['results']

  for character in characters do
  	@all_characters.push(character['name'])
  end

end

print @all_characters


get_all_characters(0)
get_all_characters(100)
get_all_characters(200)
get_all_characters(300)
get_all_characters(400)
get_all_characters(500)
get_all_characters(600)
get_all_characters(700)
get_all_characters(800)
get_all_characters(900)
get_all_characters(1000)
get_all_characters(1100)
get_all_characters(1200)
get_all_characters(1300)
get_all_characters(1400)
get_all_characters(1500)
get_all_characters(1600)


print @all_characters