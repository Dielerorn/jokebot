module Bot::DiscordCommands
    # Document your command
    # in some YARD comments here!
    module Play
      extend Discordrb::Commands::CommandContainer
      command :play do |event, link|
        video = VideoInfo.new("#{link}")
        title = video.title
        title = title.to_s
        song_path = "data/media/music/#{song_path}.ogg"
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
          #Check if file exsists already
          if File.exists?(song_path)
            #Play Music
            $currently_playing = true
            Discordrb::LOGGER.info("playing #{link}")
            event.bot.game = "Music in #{channel.name}"
            event.bot.voice_connect(event.user.voice_channel)
            event.voice.play_file(song_path)
          else
            #Download music
            begin
              Discordrb::LOGGER.info("Downloading... #{link}")
              downloadingMessage = event.send_message("Downloading...")
              command = %(sudo youtube-dl -o "#{song_path.gsub(/\.ogg$/, '.%(ext)s')}" --extract-audio --audio-format vorbis #{link})
              puts command
              system(command)
              downloadingMessage.delete
            rescue
              downloadingMessage.delete
              event.respond "There was an error downloading the song"
            end
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
end
