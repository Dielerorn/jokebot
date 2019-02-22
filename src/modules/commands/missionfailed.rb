module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Missionfailed
    extend Discordrb::Commands::CommandContainer
    command :missionfailed do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("We'll get em next time")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/missionfailed.mp3')
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
