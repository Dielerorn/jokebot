module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Howrude
    extend Discordrb::Commands::CommandContainer
    command :howrude do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("How rude")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/howrude.mp3')
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
