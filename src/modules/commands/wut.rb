module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Wut
    extend Discordrb::Commands::CommandContainer
    command :wut do |event|
      Discordrb::LOGGER.info("wut")
      event.attach_file(File.open('data/media/wut.gif'))
    end
  end
end
