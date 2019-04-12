module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Joke
    extend Discordrb::Commands::CommandContainer
    command :joke do |event|
      Discordrb::LOGGER.info("Joke sent")
      joke = File.readlines("data/jokes.db").sample.strip
      #Log Stats
      store = YAML::Store.new("data/stats.yml")
      store.transaction do
        store[:jokes_said] += 1
        nil
      end
      if event.user.voice_channel == nil || $voice_connected == false
        event.respond joke
      else
        event.respond joke
        speech = ESpeak::Speech.new("#{joke}", voice: "en-uk", :speed   => 120)
        speech.save("data/media/audio/speech.mp3")
        event.voice.play_file('data/media/audio/speech.mp3')
        File.delete("data/media/audio/speech.mp3")
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
