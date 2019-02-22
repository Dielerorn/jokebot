module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Ouch
    extend Discordrb::Commands::CommandContainer
    command :ouch do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Ouch!")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/ouch.mp3')
        event.event.voice.destroy
      end
    end
  end
end
