module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Hot
    extend Discordrb::Commands::CommandContainer
    command :hot do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Ahhhh thats hot!")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/hot.mp3')
        #Replace these with your own Server ID's
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
