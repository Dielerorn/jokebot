module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Oof
    extend Discordrb::Commands::CommandContainer
    command :oof do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("oof")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/oof.mp3')
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
