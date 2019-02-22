module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Source
    extend Discordrb::Commands::CommandContainer
    command :source do |event|
      Discordrb::LOGGER.info("Someone is looking at my source!")
      event.respond "https://github.com/Dielerorn/jokebot"
    end
  end
end
