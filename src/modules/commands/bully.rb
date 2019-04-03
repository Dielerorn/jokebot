module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Bully
    extend Discordrb::Commands::CommandContainer
    command :bully do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Y U BOOLY ME!")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/bully.mp3')
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
