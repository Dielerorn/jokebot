module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Play
    extend Discordrb::Commands::CommandContainer
    command :play do |event, link|
      song_path = 'data/media/music/song.ogg'
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        #Log Stats
        store = YAML::Store.new("data/stats.yml")
        store.transaction do
          store[:songs_played] += 1
          nil
        end
        channel = event.user.voice_channel
        $currently_playing = false
        #Download music
        begin
          Discordrb::LOGGER.info("Downloading... #{link}")
          downloadingMessage = event.send_message("Downloading...")
          command = %(sudo youtube-dl -o #{song_path} --extract-audio --audio-format vorbis #{link})
          puts command
          system(command)
          downloadingMessage.delete
        rescue
          downloadingMessage.delete
          event.respond "There was an error downloading the song"
        end
        #Play Music
        $currently_playing = true
        Discordrb::LOGGER.info("playing #{link}")
        event.bot.game = "Music in #{channel.name}"
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file(song_path)
        #Delete song file and disconnect
        sleep 5
        $currently_playing = false
        File.delete(song_path)
        #playingMessage.delete
        #progressbar.stop
        event.bot.game = "Bad Jokes 24/7"
        if $voice_connected == true
          nil
        else
          event.bot.voice_destroy(event.user.server)
        end
      end
    end
  end
end
