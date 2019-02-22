module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Say
    extend Discordrb::Commands::CommandContainer
    command :say do |event, *text|
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        text = text.join(" ")
        Discordrb::LOGGER.info("I said \"#{text}\" ")
        speech = ESpeak::Speech.new("#{text}", voice: "en-uk", :speed   => 120)
        speech.save("data/media/audio/speech.mp3")
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file('data/media/audio/speech.mp3')
        File.delete("data/media/audio/speech.mp3")
        event.bot.voice_destroy(event.user.server)
      end
    end
  end
end
