require 'net/http'
require 'uri'
require 'Digest'
require './keys.rb'
require 'json'

=begin 
working ex's
Params = {
  :ts => "ea42fbot102",
  :apikey => "2dd9e2eceeb3b2f63c26d8ac459b0a5a",
  :hash => "277e4fef41c69d41e665ac3ed3873ee3"
}

Params = {
  :ts => "2018-11-15 13:42:15 -0500 ",
  :apikey => "2dd9e2eceeb3b2f63c26d8ac459b0a5a",
  :hash => "72bb01b3f6926f6bbd8870ac4d210c7d"
}

params = {
  :ts => nonce,
  :apikey => ENV['public_key'],
  :hash => Digest::MD5.new.update(
  	nonce+ENV['private_key']+ENV['public_key']
  ),
  :name => "3-D Man"
}

Headers: {
  Accept: */*
}

gateway.marvel.com/v1/public/characters?name=spider-man&ts=2018-11-15+13%3A42%3A15+-0500+&apikey=2dd9e2eceeb3b2f63c26d8ac459b0a5a&hash=72bb01b3f6926f6bbd8870ac4d210c7d

=end

BASE_MARVEL_API_URI = 'http://gateway.marvel.com/v1/public/characters'

uri = URI(BASE_MARVEL_API_URI)

nonce=Time.now.to_s

params = {
  :ts => nonce,
  :apikey => ENV['public_key'],
  :hash => Digest::MD5.new.update(
  	nonce+ENV['private_key']+ENV['public_key']
  ),
  :name => "spider-man"
}

uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)

#puts res.body if res.is_a?(Net::HTTPSuccess)

char_bio = JSON.parse(res.body)['data']['results'][0]['description']

puts char_bio


