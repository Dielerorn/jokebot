module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Websource
    extend Discordrb::Commands::CommandContainer
    command :websource do |event|
      Discordrb::LOGGER.info("Someone is looking at my web source!")
      event.respond "https://github.com/Dielerorn/jokebot-web"
    end
  end
end
