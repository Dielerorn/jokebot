module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Triple
    extend Discordrb::Commands::CommandContainer
    command :triple do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Oh baby a triple")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/triple.mp3')
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
