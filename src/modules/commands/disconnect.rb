module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Disconnect
    extend Discordrb::Commands::CommandContainer
    command :disconnect do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("The bot disconnected from a voice channel")
        event.bot.voice_destroy(event.user.server)
        $voice_connected = false
        nil
      end
    end
  end
end
