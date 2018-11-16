require 'json'
require 'time'
require 'faraday'
require 'digest/md5'
require_relative 'request'
require_relative 'connection'
require_relative 'configuration'

module Marvel
  class Client
    include Marvel::Request
    include Marvel::Connection
    include Marvel::Configuration

    def initialize
      reset
    end

    # Requests on the server side must be of the form
    # http://gateway.marvel.com/v1/comics/?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150
    # where ts is a timestamp
    #       apikey is your public API key
    #       hash is the MD5 hash of the concatenation of
    #       ts, your private API key, and your public API key

    # All methods return an Array of Hashie::Mash objects
    # that represent the original JSON response

    # Characters:

    # fetches lists of characters
    def characters(options = {})
      # v1/public/characters
      get('characters', options)
    end

    # fetches a single character by id
    def character(id, options = {})
      # v1/public/characters/{characterId}
      get("characters/#{id}", options)
    end

    # fetches lists of comics filtered by a character id
    def character_comics(id, options = {})
      # v1/public/characters/{characterId}/comics
      get("characters/#{id}/comics", options)
    end

    # fetches lists of events filtered by a character id
    def character_events(id, options = {})
      # v1/public/characters/{characterId}/events
      get("characters/#{id}/events", options)
    end

    # fetches lists of series filtered by a character id
    def character_series(id, options = {})
      # vi/public/characters/{characterId}/series
      get("characters/#{id}/series", options)
    end

    # fetches lists of stories filtered by a character id
    def character_stories(id, options = {})
      # v1/public/characters/{characterId}/stories
      get("characters/#{id}/stories", options)
    end

  end
end