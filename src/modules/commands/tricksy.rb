module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Tricksy
    extend Discordrb::Commands::CommandContainer
    command :tricksy do |event|
      Discordrb::LOGGER.info("TRICKSY")
      event.attach_file(File.open('data/media/gollum.gif'))
    end
  end
end
