module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Abouttime
    extend Discordrb::Commands::CommandContainer
    command :abouttime do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Its about time.")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/abouttime.mp3')
        #Replace these with your own Server ID's
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
