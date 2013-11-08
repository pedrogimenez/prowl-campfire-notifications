# Requirements:
#
# PROWL_CAMPFIRE_SUBDOMAIN: The campfire subdomain of your company.
# PROWL_CAMPFIRE_USER_TOKEN: A token from a user with access to the room.
# PROWL_CAMPFIRE_ROOM: Room id. This script will be listening that room.
# PROWL_USER_API_KEY: The prowl API key of the user you want to notify.
# PROWL_USERNAME: The username you want to listen for.
#
# Author: github.com/pedrogimenez

require 'tinder'
require 'prowl'

campfire = Tinder::Campfire.new(ENV['PROWL_CAMPFIRE_SUBDOMAIN'],
                                :token => ENV['PROWL_CAMPFIRE_USER_TOKEN'])

room = campfire.find_room_by_id(ENV['PROWL_CAMPFIRE_ROOM'])

room.listen do |message|
  return unless message[:body] =~ /#{ENV['PROWL_USERNAME']}/i

  Prowl.add(
    apikey: ENV['PROWL_USER_API_KEY'],
    application: "Campfire",
    event: "#{message[:user][:name]} pinged you!",
    description: message[:body])
end
