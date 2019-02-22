module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Lies
    extend Discordrb::Commands::CommandContainer
    command :lies do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("LIES! DECEPTION!")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/lies.mp3')
        #Replace these with your own Server ID's
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
