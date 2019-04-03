module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Pranked
    extend Discordrb::Commands::CommandContainer
    #Change the 2nd number in parentheses for how many files there are
    pranked = (1..9).map { |n| "data/media/audio/pranked/#{n}.mp3" }
    command :pranked do |event|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("YOU JUST GOT PRANKED")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file(pranked.sample)
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
