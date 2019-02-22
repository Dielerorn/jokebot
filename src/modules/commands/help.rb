module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Help
    extend Discordrb::Commands::CommandContainer
    command :help do |event, command|
      command = command.downcase
      Discordrb::LOGGER.info("Someone needed help with the #{command} command")
      event.respond File.read("help/#{command}")
    end
  end
end
