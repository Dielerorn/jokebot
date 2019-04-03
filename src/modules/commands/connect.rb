module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Connect
    extend Discordrb::Commands::CommandContainer
    command :connect do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("The bot connected to a voice channel")
        event.bot.voice_connect(event.user.voice_channel)
        $voice_connected = true
        nil
      end
    end
  end
end
