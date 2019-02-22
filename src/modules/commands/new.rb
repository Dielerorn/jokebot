module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module New
    extend Discordrb::Commands::CommandContainer
    command :new do |event|
      Discordrb::LOGGER.info("Showed the new commands")
      event.respond File.read('help/new')
    end
  end
end
