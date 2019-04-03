module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Doit
    extend Discordrb::Commands::CommandContainer
    command :doit do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Do it")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/doit.mp3')
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
