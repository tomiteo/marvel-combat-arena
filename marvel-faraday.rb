require 'faraday'
require 'faraday_middleware'
require 'hashie'
require 'Digest'

=begin @client=Marvel::Client.new

{@client.configure do |config|
  config.api_key = 'YOUR_API_KEY'
  config.private_key = 'YOUR_PRIVATE_KEY'
end
=end

ts=Digest::MD5.hexdigest('#{timestamp}#{public_key}#{private_key}')


class Marvel_API
	MARVEL_API_ENDPOINT = 'https://gateway.marvel.com/v1/public/'

	attr_reader :conn

	def initialize
	    @conn = Faraday.new(url: MARVEL_API_ENDPOINT)
	end

	private

	def authentication_params
	    ts = timestamp
	    {ts: ts,
	     apikey: public_api_key,
	     hash: generate_md5(ts)
	 	}
	end

	def timestamp
	    SecureRandom.urlsafe_base64
	end

	def public_api_key
	    ENV['MARVEL_PUBLIC_API_KEY']
	end

	def private_api_key
	    ENV['MARVEL_PRIVATE_API_KEY']
	end
end

