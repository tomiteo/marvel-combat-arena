require 'faraday'
require 'digest'



BASE_API_URI = 'https://gateway.marvel.com/v1/public/'

#response = Faraday.get(BASE_API_URI)

#puts response

conn = Faraday.new(:url => BASE_API_URI)
response=conn.get('/characters?ts=thesoer&apikey=001ac6c73378bbfff488a36141458af2&hash=72e5ed53d1398abb831c3ceec263f18b')

http://gateway.marvel.com/v1/public/characters?name=spider-man
puts response.body