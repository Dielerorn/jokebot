module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Warrior
    extend Discordrb::Commands::CommandContainer
    command :warrior do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("DO YOU SEE WHAT YOU GET WHEN YOU MESS WITH THE WARRIOR?")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/warrior.mp3')
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
