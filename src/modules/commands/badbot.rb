module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Badbot
    extend Discordrb::Commands::CommandContainer
    command :badbot do |event|
      Discordrb::LOGGER.info("Bad bot")
      event.respond ":sob:"
    end
  end
end
