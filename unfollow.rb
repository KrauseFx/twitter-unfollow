require 'twitter'

class Unfollow
  def run
    raise "Please create a list called 'Old Follows'" if old_follows_list.nil?
    followings = client.following

    followings.each do |user|
      puts "Unfollowing user #{user.screen_name} (#{user.name})"
      client.add_list_member(old_follows_list, user.id)
      client.unfollow(user.id)
      `echo "#{user.screen_name}" >> unfollowed_usernames.txt`
      `echo "#{user.screen_name} (#{user.name}): #{user.description}" >> unfollowed_full_names.txt`
      sleep 1
    end
  end

  def old_follows_list
    @_old_follows_list ||= client.lists.find { |a| a.name == "Old Follows" }
  end

  def client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end
end

Unfollow.new.run
