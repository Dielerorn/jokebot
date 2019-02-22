module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Yep
    extend Discordrb::Commands::CommandContainer
    command :yep do |event|
      Discordrb::LOGGER.info("Yep")
      event.attach_file(File.open('data/media/yep.gif'))
    end
  end
end
