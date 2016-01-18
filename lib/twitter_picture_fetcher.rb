require 'twitter'
require 'dotenv'

Dotenv.load

DefaultClient = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.access_token_secret = ENV['TWITTER_OAUTH_SECRET']
end

class TwitterPictureFetcher
  attr_accessor :client
  def initialize client
    self.client = client
  end

  def get_picture_urls_by_hashtag hashtag
    self.client.search("##{hashtag} filter:images -RT", :result_type => "recent").collect {|x|
      {
        url: x.media.collect {|y| y.media_url.to_s}.flatten.uniq.first,
        user_name: x.user.screen_name.downcase
      }
    }
  end
end

