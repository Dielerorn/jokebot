module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Happybirthday
    extend Discordrb::Commands::CommandContainer
    command :happybirthday do |event, name|
      Discordrb::LOGGER.info("Birthday")
      event.respond "♪ Happy birthday to you! Happy birthday to you! Happy birthday dear #{name}! Happy birthday to you! ♪"
    end
  end
end
