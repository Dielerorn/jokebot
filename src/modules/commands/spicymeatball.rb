module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Spicymeatball
    extend Discordrb::Commands::CommandContainer
    command :spicymeatball do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Thats a spicy meatball")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/spicymeatball.mp3')
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
