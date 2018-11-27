require 'net/http'
require 'Digest'
require 'uri'
require 'json'
require './keys.rb'
require 'yaml'

@name1, @name2, @seed = nil
@all_characters = YAML.load_file('./characters.yml')
@n1bio, @n2bio = nil
BASE_MARVEL_API_URI = 'http://gateway.marvel.com/v1/public/characters'

def compare_bios (name1, name2, seed)

  name1_words_array = @n1bio.split
  name2_words_array = @n2bio.split

  #get WORD with SEED position, if array is too short, assign blank string

  n1word = begin name1_words_array[seed-1].gsub(/\W/, '') rescue '' end	
  n2word = begin name2_words_array[seed-1].gsub(/\W/, '') rescue '' end	

  #This Regex strips out all non alphanumeric characters.
  #Commas, periods, and semicolons etc. probably aren't meant to be included in the comparison,
  #but apostraphes, hyphens, and periods (like in A.I.M. or 3-D) might be,
  #so there's probably room for some finer optimization here.

  puts "#{@name1}'s word at position #{@seed} is #{n1word}"
  puts "#{@name2}'s word at position #{@seed} is #{n2word}"

  #Trump Words Logic
  if ['gamma','radioactive'].include?(n1word.downcase)
    if ['gamma','radioactive'].include?(n2word.downcase)
      return 0
    end
    return 1
  elsif ['gamma','radioactive'].include?(n2word.downcase)
    return -1
  end

  #compare WORD lengths
  n1word.length <=> n2word.length
end

#Gets Bio Field from API, assumes name is a string. 
def get_bio (name)

  char_bio = nil
  uri = URI(BASE_MARVEL_API_URI)
  nonce=Time.now.to_s
  params = {
    :ts => nonce,
    :apikey => ENV['public_key'],
    :hash => Digest::MD5.new.update(
      nonce+ENV['private_key']+ENV['public_key']
     ),
    :name => name
  }
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  #ensures that this method returns a valid bio, or false
  if res.is_a?(Net::HTTPSuccess)
  	begin
  		char_bio = JSON.parse(res.body)['data']['results'][0]['description']
  		if char_bio.split.length<1
  			throw
  		end
  	rescue
  		char_bio = false
  	end
  else
  	return false
  end
  return char_bio

end

#Begin User Interface
puts "Welcome to the Marvel Combat Arena!"
puts "You will select two characters from the Marvel Universe"
puts "And a number between 1-9"
puts "By which a winner will be chosen given the length of that numbered word in their character description from the Marvel API"
puts "'Gamma' and 'Radioactive', however, are trump words which will beat words longer than themselves."
puts "Here is the full list of the acceptable character names:"
print @all_characters
puts
puts "---------------------------------" 

#Get User Input
until !@n1bio.nil? do
	puts "Please enter a valid first Superhero/character Name"
	name = gets.chomp
	#ensure that character API query returns valid bio
	bio = get_bio(name)
	if bio == false
		puts "This character either does not exist or does not have a bio, please choose a new one"
	else
		@n1bio = bio
		@name1 = name
	end
end

until !@n2bio.nil? do
	puts "Please enter a valid second Superhero/character Name"
	name = gets.chomp
	#ensure that character API query returns valid bio
	bio = get_bio(name)
	if bio == false
		puts "This character either does not exist or does not have a bio, please choose a new one"
	else
		@n2bio = bio
		@name2 = name
	end
end

while !@seed.to_i.between?(1,9)
	puts "Please submit a number between 1-9"
	@seed = gets.chomp.to_i
end

#Business Logic
case compare_bios(@name1, @name2, @seed)
when 1
  puts "#{@name1} Wins!"
when 0
  puts 'Tie!'
when -1
  puts "#{@name2} Wins!"
end

