module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Thanks
    extend Discordrb::Commands::CommandContainer
    command :thanks do |event|
      Discordrb::LOGGER.info("Someone said thanks")
      event.respond "You're welcome!"
    end
  end
end
