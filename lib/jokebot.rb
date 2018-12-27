# A Discord bot that tells really bad jokes
require 'discordrb'
require 'dotenv'
require 'colorize'
require 'espeak'
require 'youtube-dl.rb'
require "mediainfo"
require 'ruby-progressbar'
require 'logging'

puts "########################".green
puts "#WELCOME TO THE JOKEBOT#".green
puts "########################".green

#Load .env enviroment variables
Dotenv.load('../data/.env')

#Configure logging
log = Logging.logger(STDOUT)
log.add_appenders(
    Logging.appenders.file('../logs/development.log')
)
log.level = :debug

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

bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: 446820464770154507, prefix: prefix_proc

#Variables ===========================================================================================
commands = "
Type `!commands` or `!help` for a list of the commands
Type `!new` to see the newest commands

**Commands**
`!joke`
`!istalbertbanned`
`!roll`
`!happybirthday <Name>`
`!hackertext <Text>`
`!turtle`

**Music Player**
`!play <YouTube Link>`
`!pause`
`!continue`
`!stop`

**Voice Commands**
*Must be in a voice channel to use!*
`!say <Text>`
`!countUp <Number>`
`!countDown <Number>`
`!wow`
`!hellothere`
`!nice`
`!nooo`
`!ouch`
`!doit`
`!missionfailed`
`!howrude`
`!oof`
`!omaewa`
`!goteem`
`!disappointment`
`!answer`
`!triple`
`!stupid`
`!damage`
`!onlygame`
`!trap`
`!healing`
`!spicymeatball`
`!greatsuccess`
`!playedyourself`
`!headshot`
`!spaghet`
`!pranked`
`!warrior`
`!abouttime`

**Responses**
`!thanks`
`!yep`
`!yes`
`!no`
`!lol`
`!goodbot`
`!badbot`
`!wut`
`!tricksy`
`!tastefullyracist` or `!tr`
`!whatdidyousay`

**Mini Games**
`!guessthenumber`
`!guessthenumberhard` (No hints)

**Misc**
`!howtoplaystarcraft`
`!howtogetredditkarma`
`!tragedy`
`!blackpeople`

**Dev Tools**
`!ping`
`!source`
`!websource`
`!region`
`!restart`
"

new = "
NEW FILE STRUCTURE AT `!source`

**Music Player**
Music player is now more verbose (Including a progress bar)
`!pause`
`!continue`

**Voice Commands**
`!abouttime`

**Dev Tools**
Fixed accuracy of `!region`
Improved logging
`!restart`
"

#Change the 2nd number in parentheses for how many files there are
tastefullyracist = (1..5).map { |n| "../data/media/tastefully-racist/#{n}.gif" }

tastefullyRacistCommands = [:tastefullyracist, :tr]

#Change the 2nd number in parentheses for how many files there are
pranked = (1..9).map { |n| "../data/media/audio/pranked/#{n}.mp3" }

#Letter replacements for hacker text
replacements = {
  'A' => '4', 'a' => '4', 'E' => '3', 'e' => '3', 'G' => '6', 'g' => '6', 'L' => '1', 'l' => '1', 'O' => '0', 'o' => '0', 'S' => '5', 's' => '5', 'T' => '7', 't' => '7', 'I' => '!', 'i' => '!'}

helpCommands = [:commands, :help]

#Commands =======================================================================================
bot.command helpCommands do |event|
  log.info "Someone needed help".light_red
  event.respond commands
end

bot.command :new do |event|
  log.info "Showed the new commands".light_red
  event.respond new
end

bot.command :joke do |event|
  log.info "Joke sent".green
  event.respond File.readlines("../data/jokes.db").sample.strip
end

bot.command :istalbertbanned do |event|
  log.info "I checked if Talbert was banned".green
  talbert = event.server.member(361438280757018624)
  general = bot.channel(406973058042298380)
  if talbert.can_send_messages?(general)
    event.respond "Talbert is not banned from General...yet"
  else
    event.respond "Talbert is banned from General. F in the chat for our brave meme master"
  end
end

bot.command :roll do |event|
  log.info "#{rollUser} rolled a #{rollNumber}!".light_green
  rollNumber = rand(1..100)
  rollUser = event.user.username
  if rollNumber == 100
    event.respond "#{rollUser} rolled a :100:"
  else
  event.respond "#{rollUser} rolled a #{rollNumber}!"
  end
end

bot.command :thanks do |event|
  log.info "Someone said thanks".blue
  event.respond "You're welcome!"
end

bot.command :lol do |event|
  log.info "Someone laughed".red
  event.respond "( ° ͜ ʖ °)"
end

bot.command :goodbot do |event|
  log.info "Good bot".green
  event.respond ":smile:"
end

bot.command :badbot do |event|
  log.info "Bad bot".red
  event.respond ":sob:"
end

bot.command :whatdidyousay do |event|
  log.info "Navy Seal".yellow
  event.respond "What the fuck did you just fucking say about me, you little bitch? I'll have you know I graduated top of my class in the Navy Seals, and I've been involved in numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth, mark my fucking words. You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we speak I am contacting my secret network of spies across the USA and your IP is being traced right now so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven hundred ways, and that's just with my bare hands. Not only am I extensively trained in unarmed combat, but I have access to the entire arsenal of the United States Marine Corps and I will use it to its full extent to wipe your miserable ass off the face of the continent, you little shit. If only you could have known what unholy retribution your little \"clever\" comment was about to bring down upon you, maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You're fucking dead, kiddo."
end

bot.command :tragedy do |event|
  log.info "Did you ever hear the tragedy of Darth Plagueis The Wise?".red
  event.respond "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It’s not a story the Jedi would tell you. It’s a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying. The dark side of the Force is a pathway to many abilities some consider to be unnatural. He became so powerful… the only thing he was afraid of was losing his power, which eventually, of course, he did. Unfortunately, he taught his apprentice everything he knew, then his apprentice killed him in his sleep. Ironic. He could save others from death, but not himself."
end

bot.command :howtoplaystarcraft do |event|
  log.info "A scrub got rekt".yellow
  event.respond "git gud scrub"
end

bot.command :howtogetredditkarma do |event|
  log.info "A redditor got learnt".purple
  event.respond "repost"
end

bot.command :no do |event|
  log.info "No.".orange
  event.respond "No."
end

bot.command :yes do |event|
  log.info "Yes!".green
  event.respond "Yes!"
end

bot.command :yep do |event|
  log.info "Yep".light_blue
  event.attach_file(File.open('../data/media/yep.gif'))
end

bot.command :tricksy do |event|
  log.info "TRICKSY".light_blue
  event.attach_file(File.open('../data/media/gollum.gif'))
end

bot.command :wut do |event|
  log.info "wut".light_green
  event.attach_file(File.open('../data/media/wut.gif'))
end

bot.command tastefullyRacistCommands do |event|
  log.info "Tasteful".light_yellow
  event.attach_file(File.open(tastefullyracist.sample))
end

bot.command :blackpeople do |event|
  log.info "We all know what you were expecting".red
  event.respond "We all know what you were expecting, and frankly, im surprised at you..."
end

bot.command :happybirthday do |event, name|
  log.info "Birthday!".green
  event.respond "♪ Happy birthday to you! Happy birthday to you! Happy birthday dear #{name}! Happy birthday to you! ♪"
end

bot.command :turtle do |event|
  log.info "A turtle made it to the water".green
  event.respond "A :turtle: turtle :turtle: made :turtle: it :turtle: to :turtle: the :turtle: water!"
end

bot.command :hackertext do |event, *text|
  log.info "Im in.".green
  text = text.join(" ")
  leettext = text.gsub(Regexp.union(replacements.keys), replacements)
  event.respond leettext
end

#Audio Commands =======================================================================================

bot.command :say do |event, *text|
  text = text.join(" ")
  log.info "I said \"#{text}\" ".green
  speech = ESpeak::Speech.new("#{text}", voice: "en-uk", :speed   => 120)
  speech.save("../data/media/audio/speech.mp3")
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/speech.mp3')
  File.delete("../data/media/audio/speech.mp3")
  bot.voice_destroy(event.user.server)
end

bot.command :countdown do |event, number|
  log.info "I counted down from #{number}".green
  countDownNumber = number.to_i
  countDownArray = [*1..countDownNumber].reverse
  countDownSpeech = ESpeak::Speech.new("#{countDownArray}", voice: "en-uk", :speed   => 120)
  countDownSpeech.save("../data/media/audio/countdown.mp3")
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/countdown.mp3')
  File.delete("../data/media/audio/countdown.mp3")
  bot.voice_destroy(event.user.server)
end

bot.command :countup do |event, number|
  log.info "I counted to #{number}".green
  countUpNumber = number.to_i
  countUpArray = [*1..countUpNumber]
  countUpSpeech = ESpeak::Speech.new("#{countUpArray}", voice: "en-uk", :speed   => 120)
  countUpSpeech.save("../data/media/audio/countup.mp3")
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/countup.mp3')
  File.delete("../data/media/audio/countup.mp3")
  bot.voice_destroy(event.user.server)
end

bot.command :wow do |event|
  log.info "WOW".yellow
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/wow.mp3')
  bot.voice_destroy(event.user.server)
end


bot.command :hellothere do |event|
  log.info "Hello There!".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/hellothere.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :nice do |event|
  log.info "Nice!".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/nice.mp3')
  bot.voice_destroy(event.user.server)
end


bot.command :ouch do |event|
  log.info "Ouch!".yellow
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/ouch.mp3')
  #Replace these with your own Server ID's
  event.voice.destroy
end

bot.command :doit do |event|
  log.info "Dewwit".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/doit.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :oof do |event|
  log.info "oof".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/oof.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :missionfailed do |event|
  log.info "We'll Get Em Next Time".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/missionfailed.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :howrude do |event|
  log.info "How Rude".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/howrude.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :omaewa do |event|
  log.info "NANI?!?!".red
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/omaewa.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :goteem do |event|
  log.info "GOTEEM".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/goteem.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :disappointment do |event|
  log.info "My day is ruined".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/disappointment.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :answer do |event|
  log.info "Answer the question!".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/answer.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :triple do |event|
  log.info "Oh baby a triple!".red
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/triple.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :stupid do |event|
  log.info "Stupid!".yellow
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/stupid.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :damage do |event|
  log.info "NOW THATS A LOTTA DAMAGE!".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/damage.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :onlygame do |event|
  log.info "Why you heff to be mad?".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/onlygame.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :trap do |event|
  log.info "Its a trap!".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/trap.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :healing do |event|
  log.info "I NEED HEALING".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/healing.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :spicymeatball do |event|
  log.info "Thats a spicy meatball!".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/spicymeatball.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :greatsuccess do |event|
  log.info "Iz great success".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/greatsuccess.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :playedyourself do |event|
  log.info "You played yourself".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/playedyourself.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :headshot do |event|
  log.info "BOOM HEADSHOT".red
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/headshot.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :nooo do |event|
  log.info "NOOOOOOO".red
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/nooo.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :spaghet do |event|
  log.info "SOMEBODY TOUCHA MY SPAGHET".red
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/spaghet.mp3')
  bot.voice_destroy(event.user.server)
end

bot.command :pranked do |event|
  log.info "YOU JUST GOT PRANKED".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file(pranked.sample)
  bot.voice_destroy(event.user.server)
end

bot.command :warrior do |event|
  log.info "DO YOU SEE WHAT YOU GET WHEN YOU MESS WITH THE WARRIOR".red
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/warrior.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(event.user.server)
end

bot.command :abouttime do |event|
  log.info "Its about time.".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/audio/abouttime.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(event.user.server)
end

# Music Player =====================================================================================
bot.command :play do |event, link|
  channel = event.user.voice_channel
  currentlyPlaying = false
  #Download music
  log.info "Downloading... #{link}".green
  downloadingMessage = event.send_message("Downloading...")
  YoutubeDL.get "#{link}", extract_audio: true, audio_format: 'mp3',  output: '../data/media/music/song.mp3'
  downloadingMessage.delete
  #Get audio data
  media_info = MediaInfo.from('../data/media/music/song.mp3')
  songLength = media_info.audio.duration / 1000 #Song Length in seconds
  songLengthMinutes = [songLength / 3600, songLength / 60 % 60, songLength % 60].map { |t| t.to_s.rjust(2,'0') }.join(':') #Convert seconds into hours:minutes:seconds format
  puts "Song is #{songLength} seconds long".green
  puts "Song is #{songLengthMinutes} minutes long".green
  #Progress Bar
  progressbar = ProgressBar.create(:title => "Playing in #{channel.name}   00:00 ", :starting_at => 0, :total => songLength, :remainder_mark => "-", :progress_mark => "#", :length => 140)
  playingMessage = event.send_message("#{progressbar} #{songLengthMinutes}")
  Thread.new do
    while currentlyPlaying == true do
      sleep 7
      7.times { progressbar.increment } #Increment the progress bar by 1 second
      playingMessage.edit "#{progressbar} #{songLengthMinutes}"
    end
  end
  #End of Progress Bar
  #Play Music
  currentlyPlaying = true
  log.info "Playing... #{link}".green
  bot.game = "Music in #{channel.name}"
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('../data/media/music/song.mp3')
  #Delete song file and disconnect
  sleep 10
  currentlyPlaying = false
  File.delete("../data/media/music/song.mp3")
  playingMessage.delete
  bot.game = "Bad Jokes 24/7"
  bot.voice_destroy(event.user.server)
end

bot.command :pause do |event|
  log.info "Audio paused".blue
  event.voice.pause
  progressbar.pause
  bot.game = "Music paused in #{channel.name}"
  nil
end

bot.command :continue do |event|
  log.info "Audio continued".blue
  event.voice.continue
  bot.game = "Music in #{channel.name}"
  nil
end

bot.command :stop do |event|
  log.info "Audio Stopped".red
  bot.voice_destroy(event.user.server)
  progressbar.stop
  bot.game = "Bad Jokes 24/7"
  nil
end

# Mini Games =======================================================================================
bot.message(start_with: '!guessthenumber') do |event|
  log.info "Guess the number!".green
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
  log.info "Guess the number HARD!".red
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
  log.info "Ping!".blue
  # The `respond` method returns a `Message` object, which is stored in a variable `m`. The `edit` method is then called
  # to edit the message with the time difference between when the event was received and after the message was sent.
  m = event.respond('Pong!')
  m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

bot.command :source do |event|
  log.info "Someone is looking at my source".blue
  event.respond "https://github.com/Dielerorn/jokebot"
end

bot.command :websource do |event|
  log.info "Someone is looking at my web source".blue
  event.respond "https://github.com/Dielerorn/jokebot-web"
end

bot.command(:region, chain_usable: false, description: "Gets the region the server is stationed in.") do |event|
  log.info "Getting Region".yellow
  event.server.region
end

bot.command :restart do |event|
  log.info "I was restarted".red
  event.respond "Restarting..."
  exec "./run.sh"
end

# ======================================================

bot.ready do
  bot.game = "Bad Jokes 24/7"
end

bot.run
