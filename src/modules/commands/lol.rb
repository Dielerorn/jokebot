module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Lol
    extend Discordrb::Commands::CommandContainer
    command :lol do |event|
      Discordrb::LOGGER.info("Someone laughed")
      event.respond "( ° ͜ ʖ °)"
    end
  end
end
