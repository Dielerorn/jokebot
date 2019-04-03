module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Onlygame
    extend Discordrb::Commands::CommandContainer
    command :onlygame do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Why you heff to be mad?")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/onlygame.mp3')
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
