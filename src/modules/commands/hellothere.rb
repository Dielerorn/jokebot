module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Hellothere
    extend Discordrb::Commands::CommandContainer
    command :hellothere do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Hello there!")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/hellothere.mp3')
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
