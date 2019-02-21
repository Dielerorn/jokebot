# A Discord bot that tells really bad jokes
require 'discordrb'
require 'dotenv'
require 'espeak'
require 'youtube-dl.rb'
require "mediainfo"
require 'ruby-progressbar'
require 'usagewatch'
require 'mini_magick'
require 'open-uri'

puts "WELCOME TO THE JOKEBOT"

#Load .env in a new path (Change require 'dotenv/load' to require 'dotenv' when using this)
Dotenv.load('../data/.env')

#Configure Logging without the gem
start_time = Time.now.strftime("%F %R") # 2019-01-30 15:04
logs_file = File.open("../logs/#{start_time}-development.log", "w") # 2019-01-30 15:04-development.log
Discordrb::LOGGER.streams << logs_file

#Configure usagewatch
usw = Usagewatch

#Specify alternate path to MediaInfo
ENV['MEDIAINFO_PATH'] = "/usr/bin/mediainfo"

#Make commands case insensitive
prefix_proc = proc do |message|
  # Extract the first word and the rest of the message,
  # and ignore the message if it doesn't start with "!":
  match = /^\!(\w+)(.*)/.match(message.content)
  if match
    first = match[1]
    rest = match[2]
    # Return the modified string with the first word lowercase:
    "#{first.downcase}#{rest}"
  end
end

bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: 446820464770154507, log_mode: :normal, prefix: prefix_proc

#Variables ===========================================================================================

#Change the 2nd number in parentheses for how many files there are
tastefullyracist = (1..5).map { |n| "../data/media/tastefully-racist/#{n}.gif" }

tastefullyRacistCommands = [:tastefullyracist, :tr]

#Change the 2nd number in parentheses for how many files there are
pranked = (1..9).map { |n| "../data/media/audio/pranked/#{n}.mp3" }

#Change the 2nd number in parentheses for how many files there are
emojis = (1..15).map { |n| "../data/media/emojis/#{n}.png" }

#Letter replacements for hacker text
replacements = {
  'A' => '4', 'a' => '4', 'E' => '3', 'e' => '3', 'G' => '6', 'g' => '6', 'L' => '1', 'l' => '1', 'O' => '0', 'o' => '0', 'S' => '5', 's' => '5', 'T' => '7', 't' => '7', 'I' => '!', 'i' => '!'}

  Emoji = {
    white_check_mark: "\u{2705}",
    x: "\u{274C}"
  }

voice_channel_error = "User must be in a voice channel"

#Commands =======================================================================================
bot.command :commands do |event|
  Discordrb::LOGGER.info("Someone needed help")
  event.respond File.read('../help/commands')
end

bot.command :help do |event, command|
  command = command.downcase
  Discordrb::LOGGER.info("Someone needed help with the #{command} command")
  event.respond File.read("../help/#{command}")
end

bot.command :new do |event|
  Discordrb::LOGGER.info("Showed the new commands")
  event.respond File.read('../help/new')
end

bot.command :joke do |event|
  Discordrb::LOGGER.info("Joke sent")
  event.respond File.readlines("../data/jokes.db").sample.strip
end

bot.command :istalbertbanned do |event|
  Discordrb::LOGGER.info("Checked if Talbert was banned from general")
  talbert = event.server.member(361438280757018624)
  general = bot.channel(406973058042298380) #General channel on the Colorado Casuals server
  if talbert.can_send_messages?(general)
    event.respond "Talbert is not banned from General...yet"
  else
    event.respond "Talbert is banned from General. F in the chat for our brave meme master"
  end
end

bot.command :roll do |event|
  rollNumber = rand(1..100)
  rollUser = event.user.username
  Discordrb::LOGGER.info("#{rollUser} rolled a #{rollNumber}")
  if rollNumber == 100
    event.respond "#{rollUser} rolled a :100:"
  else
  event.respond "#{rollUser} rolled a #{rollNumber}!"
  end
end

bot.command :vote do |event, *topic|
  topic = topic.join(" ")
  Discordrb::LOGGER.info("We voted on #{topic}")
  event.message.delete #Delete the message that initiated this command for the sake of anonymity
  votingMessage = event.send_message("**#{topic}**")
  votingMessage.react(Emoji[:white_check_mark])
  votingMessage.react(Emoji[:x])
end

bot.command :nickname do |event, *name|
  botUser = event.server.member(bot.profile)
  name = name.join(" ")
  if name == nil
    event.respond "My nickname was reset"
  else
    botUser.nick=(name)
    event.respond "My nickname was changed to #{name}"
    Discordrb::LOGGER.info("Nickname changed to #{name}")
    nil
  end
end

bot.command :hackertext do |event, *text|
  Discordrb::LOGGER.info("Im in")
  text = text.join(" ")
  leettext = text.gsub(Regexp.union(replacements.keys), replacements)
  event.respond leettext
end

bot.command :deepfry do |event|
  Discordrb::LOGGER.info("I deep fried the most recent image")
  #Find the recent image by checking the channel history and filtering it
  recent_messages = event.channel.history(15) #Only search the last 15 messages in the channel
  image_message = recent_messages.find { |m| m.attachments.any?(&:image?) }
  attachment = image_message.attachments.find(&:image?)
  #Download the image
  download = open(attachment.url)
  IO.copy_stream(download, '../data/media/temp/deepfry.jpg')
  #Deepfry the image
  processing_message = event.send_message("Processing...")
  image = MiniMagick::Image.new("../data/media/temp/deepfry.jpg")
  image_width = image.dimensions[0]
  image_height = image.dimensions[1]
  rand(1..4).times do #This bLock composites the emojis, randomizing between 1-4 emojis added
    chosen_emoji = MiniMagick::Image.open("#{emojis.sample}")
    chosen_emoji_scaled = chosen_emoji.resize "#{image_width / rand(4..8)}x#{image_height / rand(4..8)}"
    chosen_emoji_scaled.write "../data/media/temp/emoji.png"
    result = image.composite(MiniMagick::Image.new("../data/media/temp/emoji.png")) do |c|
      c.compose "Over"
      c.geometry "+#{image.dimensions[0] / rand(1..8)}+#{image.dimensions[1] / rand(1..8)}"
    end
    result.write "../data/media/temp/deepfry.jpg"
  end
  image.combine_options do |b|
    b.quality "5"
    rand(4..16).times { b.contrast }
    4.times {b.noise.+ "Gaussian"}
    b.colorize "15,0,0"
    b.brightness_contrast "-6"
    b.distort("shepards", "#{rand(1..250)},#{rand(1..250)} #{rand(1..250)},#{rand(1..250)} #{rand(1..250)},#{rand(1..250)} #{rand(1..250)},#{rand(1..250)}")
  end
  #Send the final version and delete the file
  processing_message.delete
  event.attach_file(File.open('../data/media/temp/deepfry.jpg'))
  File.delete("../data/media/temp/deepfry.jpg")
  File.delete("../data/media/temp/emoji.png")
  nil
end

bot.command :thanks do |event|
  Discordrb::LOGGER.info("Someone said thanks")
  event.respond "You're welcome!"
end

bot.command :lol do |event|
  Discordrb::LOGGER.info("Someone laughed")
  event.respond "( ° ͜ ʖ °)"
end

bot.command :goodbot do |event|
  Discordrb::LOGGER.info("Good bot")
  event.respond ":smile:"
end

bot.command :badbot do |event|
  Discordrb::LOGGER.info("Bad bot")
  event.respond ":sob:"
end

bot.command :whatdidyousay do |event|
  Discordrb::LOGGER.info("Navy Seal")
  event.respond "What the fuck did you just fucking say about me, you little bitch? I'll have you know I graduated top of my class in the Navy Seals, and I've been involved in numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth, mark my fucking words. You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we speak I am contacting my secret network of spies across the USA and your IP is being traced right now so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven hundred ways, and that's just with my bare hands. Not only am I extensively trained in unarmed combat, but I have access to the entire arsenal of the United States Marine Corps and I will use it to its full extent to wipe your miserable ass off the face of the continent, you little shit. If only you could have known what unholy retribution your little \"clever\" comment was about to bring down upon you, maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You're fucking dead, kiddo."
end

bot.command :tragedy do |event|
  Discordrb::LOGGER.info("Tragedy of Dark Plagueis the Wise")
  event.respond "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It’s not a story the Jedi would tell you. It’s a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying. The dark side of the Force is a pathway to many abilities some consider to be unnatural. He became so powerful… the only thing he was afraid of was losing his power, which eventually, of course, he did. Unfortunately, he taught his apprentice everything he knew, then his apprentice killed him in his sleep. Ironic. He could save others from death, but not himself."
end

bot.command :howtoplaystarcraft do |event|
  Discordrb::LOGGER.info("A scrub got rekt")
  event.respond "git gud scrub"
end

bot.command :howtogetredditkarma do |event|
  Discordrb::LOGGER.info("A redditor got learnt")
  event.respond "repost"
end

bot.command :yep do |event|
  Discordrb::LOGGER.info("Yep")
  event.attach_file(File.open('../data/media/yep.gif'))
end

bot.command :tricksy do |event|
  Discordrb::LOGGER.info("TRICKSY")
  event.attach_file(File.open('../data/media/gollum.gif'))
end

bot.command :wut do |event|
  Discordrb::LOGGER.info("wut")
  event.attach_file(File.open('../data/media/wut.gif'))
end

bot.command tastefullyRacistCommands do |event|
  Discordrb::LOGGER.info("Tasteful")
  event.attach_file(File.open(tastefullyracist.sample))
end

bot.command :happybirthday do |event, name|
  Discordrb::LOGGER.info("Birthday")
  event.respond "♪ Happy birthday to you! Happy birthday to you! Happy birthday dear #{name}! Happy birthday to you! ♪"
end

#Audio Commands =======================================================================================

bot.command :say do |event, *text|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    text = text.join(" ")
    Discordrb::LOGGER.info("I said \"#{text}\" ")
    speech = ESpeak::Speech.new("#{text}", voice: "en-uk", :speed   => 120)
    speech.save("../data/media/audio/speech.mp3")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/speech.mp3')
    File.delete("../data/media/audio/speech.mp3")
    bot.voice_destroy(event.user.server)
  end
end

bot.command :countdown do |event, number|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("I counted down from #{number}")
    countDownNumber = number.to_i
    countDownArray = [*1..countDownNumber].reverse
    countDownSpeech = ESpeak::Speech.new("#{countDownArray}", voice: "en-uk", :speed   => 120)
    countDownSpeech.save("../data/media/audio/countdown.mp3")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/countdown.mp3')
    File.delete("../data/media/audio/countdown.mp3")
    bot.voice_destroy(event.user.server)
  end
end

bot.command :countup do |event, number|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("I counted to #{number}")
    countUpNumber = number.to_i
    countUpArray = [*1..countUpNumber]
    countUpSpeech = ESpeak::Speech.new("#{countUpArray}", voice: "en-uk", :speed   => 120)
    countUpSpeech.save("../data/media/audio/countup.mp3")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/countup.mp3')
    File.delete("../data/media/audio/countup.mp3")
    bot.voice_destroy(event.user.server)
  end
end

bot.command :wow do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("WOW")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/wow.mp3')
    bot.voice_destroy(event.user.server)
  end
end


bot.command :hellothere do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Hello there!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/hellothere.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :nice do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Nice!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/nice.mp3')
    bot.voice_destroy(event.user.server)
  end
end


bot.command :ouch do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Ouch!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/ouch.mp3')
    #Replace these with your own Server ID's
    event.voice.destroy
  end
end

bot.command :doit do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Do it")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/doit.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :oof do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("oof")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/oof.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :missionfailed do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("We'll get em next time")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/missionfailed.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :howrude do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("How rude")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/howrude.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :omaewa do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("NANI?!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/omaewa.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :goteem do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("GOTEEM")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/goteem.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :disappointment do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("My day is ruined")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/disappointment.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :answer do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Answer the question")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/answer.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :triple do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Oh baby a triple")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/triple.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :stupid do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Stupid!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/stupid.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :damage do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("NOW THATS A LOTTA DAMAGE")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/damage.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :onlygame do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Why you heff to be mad?")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/onlygame.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :trap do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Its a trap!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/trap.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :healing do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("I need healing!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/healing.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :spicymeatball do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Thats a spicy meatball")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/spicymeatball.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :greatsuccess do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Iz great success")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/greatsuccess.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :playedyourself do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("You played yourself")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/playedyourself.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :headshot do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("BOOM HEADSHOT")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/headshot.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :nooo do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("NOOOOO!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/nooo.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :spaghet do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("SOMEBODY TOUCHA MY SPAGHET")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/spaghet.mp3')
    bot.voice_destroy(event.user.server)
  end
end

bot.command :pranked do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("YOU JUST GOT PRANKED")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file(pranked.sample)
    bot.voice_destroy(event.user.server)
  end
end

bot.command :warrior do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("DO YOU SEE WHAT YOU GET WHEN YOU MESS WITH THE WARRIOR?")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/warrior.mp3')
    #Replace these with your own Server ID's
    bot.voice_destroy(event.user.server)
  end
end

bot.command :abouttime do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Its about time.")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/abouttime.mp3')
    #Replace these with your own Server ID's
    bot.voice_destroy(event.user.server)
  end
end

bot.command :hot do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Ahhhh thats hot!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/hot.mp3')
    #Replace these with your own Server ID's
    bot.voice_destroy(event.user.server)
  end
end

bot.command :violence do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("VIOLENCE SPEED MOMENTUM")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/violence.mp3')
    #Replace these with your own Server ID's
    bot.voice_destroy(event.user.server)
  end
end

bot.command :no do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("NO!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/no.mp3')
    #Replace these with your own Server ID's
    bot.voice_destroy(event.user.server)
  end
end

bot.command :bully do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("Y U BOOLY ME!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/bully.mp3')
    #Replace these with your own Server ID's
    bot.voice_destroy(event.user.server)
  end
end

bot.command :lies do |event|
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    Discordrb::LOGGER.info("LIES! DECEPTION!")
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file('../data/media/audio/lies.mp3')
    #Replace these with your own Server ID's
    bot.voice_destroy(event.user.server)
  end
end

# Music Player =====================================================================================
bot.command :play do |event, link|
  song_path = '../data/media/music/song.mp3'
  if event.user.voice_channel == nil
    event.respond voice_channel_error
  else
    channel = event.user.voice_channel
    currentlyPlaying = false
    #Download music
    Discordrb::LOGGER.info("Downloading... #{link}")
    downloadingMessage = event.send_message("Downloading...")
    YoutubeDL.get "#{link}", playlist: false, extract_audio: true, audio_format: 'mp3',  output: song_path
    downloadingMessage.delete
    #Get audio data
    mediaInfo = MediaInfo.from(song_path)
    songLength = mediaInfo.audio.duration / 1000 #Song Length in seconds
    songLengthMinutes = [songLength / 3600, songLength / 60 % 60, songLength % 60].map { |t| t.to_s.rjust(2,'0') }.join(':') #Convert seconds into hours:minutes:seconds format
    Discordrb::LOGGER.info("Song is #{songLength} seconds long")
    Discordrb::LOGGER.info("Song is #{songLengthMinutes} minutes long")
    #Progress Bar
    progressbar = ProgressBar.create(:title => "Playing in #{channel.name}   00:00 ", :starting_at => 0, :total => songLength, :remainder_mark => "-", :progress_mark => "#", :length => 140)
    playingMessage = event.send_message("#{progressbar} #{songLengthMinutes}")
    Thread.new do
      while currentlyPlaying == true do
        sleep 7 #Sleep to prevent rate limiting on the Discord API
        7.times { progressbar.increment } #Increment the progress bar (7 times because it sleeps for 7 seconds)
        playingMessage.edit "#{progressbar} #{songLengthMinutes}"
      end
    end
    #End of Progress Bar
    #Play Music
    currentlyPlaying = true
    Discordrb::LOGGER.info("playing #{link}")
    bot.game = "Music in #{channel.name}"
    bot.voice_connect(event.user.voice_channel)
    event.voice.play_file(song_path)
    #Delete song file and disconnect
    sleep 5
    currentlyPlaying = false
    File.delete("../data/media/music/song.mp3")
    playingMessage.delete
    progressbar.stop
    bot.game = "Bad Jokes 24/7"
    bot.voice_destroy(event.user.server)
  end
end

bot.command :pause do |event|
  Discordrb::LOGGER.info("Audio paused")
  event.voice.pause
  progressbar.pause
  bot.game = "Music paused in #{channel.name}"
  nil
end

bot.command :continue do |event|
  Discordrb::LOGGER.info("Audio continued")
  event.voice.continue
  bot.game = "Music in #{channel.name}"
  nil
end

bot.command :stop do |event|
  if event.user.id == 221416570142851082
    event.respond "Corbin cant do that"
  else
    Discordrb::LOGGER.info("Audio stopped")
    bot.voice_destroy(event.user.server)
    File.delete("../data/media/music/song.mp3")
    bot.game = "Bad Jokes 24/7"
    progressbar.stop
    nil
  end
end

# Mini Games =======================================================================================
bot.message(start_with: '!guessthenumber') do |event|
  Discordrb::LOGGER.info("Guess the number!")
  magic = rand(1..10)
  event.user.await(:guess) do |guess_event|
    guess = guess_event.message.content.to_i
    if guess == magic
      guess_event.respond ':white_check_mark: Well guessed!'
    else
      guess_event.respond(guess > magic ? ':x: Too high' : ':x: Too low')
      false
    end
  end
  event.respond 'Guess a number between 1 and 10: '
end

bot.message(start_with: '!guessthenumberhard') do |event|
  Discordrb::LOGGER.info("Guess the number HARD")
  magic = rand(1..10)
  event.user.await(:guess) do |guess_event|
    guess = guess_event.message.content.to_i
    if guess == magic
      guess_event.respond ':white_check_mark: Well guessed!'
    else
      guess_event.respond ':x: Wrong! Guess again: '
      false
    end
  end
  event.respond 'Guess a number between 1 and 10: '
end


# Dev Tools =======================================================================================
bot.message(content: '!ping') do |event|
  Discordrb::LOGGER.info("Ping!")
  # The `respond` method returns a `Message` object, which is stored in a variable `m`. The `edit` method is then called
  # to edit the message with the time difference between when the event was received and after the message was sent.
  m = event.respond('Pong!')
  m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

bot.command :source do |event|
  Discordrb::LOGGER.info("Someone is looking at my source!")
  event.respond "https://github.com/Dielerorn/jokebot"
end

bot.command :websource do |event|
  Discordrb::LOGGER.info("Someone is looking at my web source!")
  event.respond "https://github.com/Dielerorn/jokebot-web"
end

bot.command(:region, chain_usable: false, description: "Gets the region the server is stationed in.") do |event|
  Discordrb::LOGGER.info("Getting Region")
  event.server.region
end

#Restart command
bot.command :restart do |event|
  Discordrb::LOGGER.info("Restarting...")
  event.respond "Restarting..."
  bot.stop
  exec "./run.sh restart #{event.channel.id}"
end

handler = bot.ready do
  Discordrb::LOGGER.info("The bot is back up!")
  if ARGV[0] == "restart"
    bot.send_message(ARGV[1], "Done!")
  end
  bot.remove_handler(handler)
end
#End of restart command

bot.command :logs do |event|
  log_files = Dir["../logs/*"].reverse #Reverse the array so that the latest log files are listed first
  log_number = 0
  Discordrb::LOGGER.info("Someone downloaded the log files")
    event.respond "**Which log would you like to see?**"
    log_files.each {
      |log|
      event.respond "`#{log_number}: #{log}`"
      log_number += 1
      break if log_number == 4 #Only show 4 log files so that we dont get into trouble with the rate limiter
    }
    event.user.await(:log_choice) do |log_choice_event|
      choice = log_choice_event.message.content.to_i
      Discordrb::LOGGER.info("Log number #{choice} was chosen")
      event.respond "**Sending Log File #{choice}...**"
      log_choice_event.channel.send_file(File.open(log_files[choice]))
    end
    nil
end

bot.command :usage do |event|
  Discordrb::LOGGER.info("Somebody checked the system resource usage")
  event << "#{usw.uw_diskused} Gigabytes Disk Used"
  event << "#{usw.uw_cpuused} CPU Used"
  event << "#{usw.uw_tcpused} TCP Connections Used"
  event << "#{usw.uw_udpused} UDP Connections Used"
  event << "#{usw.uw_memused} Active Memory Used"
  event << "#{usw.uw_load} Average System Load Of The Past Minute"
  event << "#{usw.uw_bandrx} Mbit/s Current Bandwidth Received"
  event << "#{usw.uw_bandtx} Mbit/s Current Bandwidth Transmitted"
  event << "#{usw.uw_diskioreads} Current Disk Reads Completed"
  event << "#{usw.uw_diskiowrites} Current Disk Writes Completed"
  event << "Top Ten Processes By CPU Consumption:"
  event << usw.uw_cputop
  event << "Top Ten Processes By Memory Consumption:"
  event << usw.uw_memtop
end

# ======================================================

#When the bot is configured, and ready to start, run this code
bot.ready do
  bot.game = "Bad Jokes 24/7"
end

bot.run
