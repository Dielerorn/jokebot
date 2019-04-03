module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Countdown
    extend Discordrb::Commands::CommandContainer
    command :countdown do |event, number|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        Discordrb::LOGGER.info("I counted down from #{number}")
        countDownNumber = number.to_i
        countDownArray = [*1..countDownNumber].reverse
        countDownSpeech = ESpeak::Speech.new("#{countDownArray}", voice: "en-uk", :speed   => 120)
        countDownSpeech.save("data/media/audio/countdown.mp3")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/countdown.mp3')
        File.delete("data/media/audio/countdown.mp3")
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
