require 'securerandom'
require 'digest'

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
	    Time.now.to_s
	end

	def public_api_key
	    ENV['MARVEL_PUBLIC_API_KEY']
	end

	def private_api_key
	    ENV['MARVEL_PRIVATE_API_KEY']
	end

	def generate_md5(timestamp)
    	Digest::MD5.new.update("#{timestamp}#{private_api_key}#{public_api_key}").to_s
    end
end
