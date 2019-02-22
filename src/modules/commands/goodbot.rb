module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Goodbot
    extend Discordrb::Commands::CommandContainer
    command :goodbot do |event|
      Discordrb::LOGGER.info("Good bot")
      event.respond ":smile:"
    end
  end
end
