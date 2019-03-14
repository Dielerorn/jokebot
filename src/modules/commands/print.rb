module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Code
    extend Discordrb::Commands::CommandContainer
    command :print do |event, folder, command|
      Discordrb::LOGGER.info("Someone showed the source for #{command}")
      command = command.downcase
      command_file = File.read("src/modules/#{folder}/#{command}.rb")
      if command_file.size > 2000
        event.respond "Code exceeds character limit. Sending file..."
        event.attach_file(File.open("src/modules/#{folder}/#{command}.rb"))
      else
        event << "```Ruby"
        event << "#{command_file}"
        event << "```"
      end
    end
  end
end
