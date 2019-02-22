module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Greatsuccess
    extend Discordrb::Commands::CommandContainer
    command :greatsuccess do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Iz great success")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/greatsuccess.mp3')
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
