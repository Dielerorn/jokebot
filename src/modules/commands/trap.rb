module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Trap
    extend Discordrb::Commands::CommandContainer
    command :trap do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("Its a trap!")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/trap.mp3')
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
