module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Commands
    extend Discordrb::Commands::CommandContainer
    command :commands do |event|
      Discordrb::LOGGER.info("Someone needed help")
      event.respond File.read('help/commands')
    end
  end
end
