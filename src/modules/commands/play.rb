module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Play
    extend Discordrb::Commands::CommandContainer
    command :play do |event, link|
      song_path = 'data/media/music/song.mp3'
      if event.user.voice_channel == nil
        event.respond $voice_channel_error
      else
        channel = event.user.voice_channel
        currentlyPlaying = false
        #Download music
        begin
          Discordrb::LOGGER.info("Downloading... #{link}")
          downloadingMessage = event.send_message("Downloading...")
          YoutubeDL.get "#{link}", playlist: false, extract_audio: true, audio_format: 'mp3', format: :bestaudio,  output: song_path
          downloadingMessage.delete
        rescue
          downloadingMessage.delete
          event.respond "There was an error downloading the song"
        end
        #Get audio data
        mediaInfo = MediaInfo.from(song_path)
        songLength = mediaInfo.audio.duration.to_i / 1000 #Song Length in seconds
        songLengthMinutes = [songLength / 3600, songLength / 60 % 60, songLength % 60].map { |t| t.to_s.rjust(2,'0') }.join(':') #Convert seconds into hours:minutes:seconds format
        Discordrb::LOGGER.info("Song is #{songLength} seconds long")
        Discordrb::LOGGER.info("Song is #{songLengthMinutes} minutes long")
        #Progress Bar
        progressbar = ProgressBar.create(:title => "Playing in #{channel.name}   00:00 ", :starting_at => 0, :total => songLength, :remainder_mark => "-", :progress_mark => "#", :length => 140)
        playingMessage = event.send_message(":loud_sound: #{progressbar} #{songLengthMinutes}")
        Thread.new do
          while currentlyPlaying == true do
            sleep 7 #Sleep to prevent rate limiting on the Discord API
            7.times { progressbar.increment } #Increment the progress bar (7 times because it sleeps for 7 seconds)
            playingMessage.edit ":loud_sound: #{progressbar} #{songLengthMinutes}"
          end
        end
        #End of Progress Bar
        #Play Music
        currentlyPlaying = true
        Discordrb::LOGGER.info("playing #{link}")
        event.bot.game = "Music in #{channel.name}"
        event.bot.voice_connect(event.user.voice_channel)
        event.voice.play_file(song_path)
        #Delete song file and disconnect
        sleep 5
        currentlyPlaying = false
        File.delete(song_path)
        playingMessage.delete
        progressbar.stop
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
