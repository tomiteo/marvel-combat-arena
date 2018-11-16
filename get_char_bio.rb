require 'net/http'
require 'uri'
require 'Digest'
require './keys.rb'
require 'json'

BASE_MARVEL_API_URI = 'http://gateway.marvel.com/v1/public/characters'

def get_bio (name)
  
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
  char_bio = JSON.parse(res.body)['data']['results'][0]['description']
  return char_bio

end


def compare_bios (name1, name2, seed)

  name1_words_array = get_bio(name1).split
  name2_words_array = get_bio(name2).split

  n1word = 'radioactive'
  n2word = name2_words_array[seed-1].gsub(/\W/, '')

  puts n1word
  puts n2word

  if ['gamma','radioactive'].include?(n1word)
    if ['gamma','radioactive'].include?(n2word)
      return 0
    end
    return 1
  elsif ['gamma','radioactive'].include?(n2word)
    return -1
  end

  n1word.length <=> n2word.length

  #return [name1_seed_word,name2_seed_word].max_by(&:length) unless 
  #  name1_seed_word || name2_seed_word == "Gamma" || "Radioactive"
  #    name1_seed_word == "Gamma" || name1_seed_word == "Radioactive" ? name1_seed_word : name2_seed_word 
end

case compare_bios('spider-man','A.I.M.', 5)
when 1
  puts 'spider-man'
when 0
  puts 'tie'
when -1
  puts 'A.I.M.'
end

#puts res.body if res.is_a?(Net::HTTPSuccess)


