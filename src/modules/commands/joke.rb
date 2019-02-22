module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Joke
    extend Discordrb::Commands::CommandContainer
    command :joke do |event|
      Discordrb::LOGGER.info("Joke sent")
      event.respond File.readlines("data/jokes.db").sample.strip
    end
  end
end
