module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Thot
    extend Discordrb::Commands::CommandContainer
    command :thot do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("If she breathes, shes a THOT")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/thot.mp3')
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
