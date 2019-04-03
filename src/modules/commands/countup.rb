module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Countup
    extend Discordrb::Commands::CommandContainer
    command :countup do |event, number|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("I counted to #{number}")
        countUpNumber = number.to_i
        countUpArray = [*1..countUpNumber]
        countUpSpeech = ESpeak::Speech.new("#{countUpArray}", voice: "en-uk", :speed   => 120)
        countUpSpeech.save("data/media/audio/countup.mp3")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/countup.mp3')
        File.delete("data/media/audio/countup.mp3")
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
