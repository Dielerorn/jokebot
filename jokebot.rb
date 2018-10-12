# A Discord Jokebot that tells really bad jokes
require 'discordrb'
require 'colorize'
require 'espeak'

#Bot and Token Config
bot = Discordrb::Commands::CommandBot.new token: 'TOKEN_HERE', client_id: CLIENT_ID_HERE, prefix: '!'

#Variables
commands = "
Type `!commands` or `!help` for a list of the commands

**Commands**
`!joke`
`!happybirthday <Name>`

**Voice Commands**
*Must be in a voice channel to use!*
`!say <Text>`
`!wow`
`!hellothere`
`!nice`
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
`!tastefullyracist`
`!tr` *(Short version of `!tastefullyracist`)*
`!whatdidyousay`

**Misc**
`!howtoplaystarcraft`
`!howtogetredditkarma`
`!tragedy`
`!blackpeople`

**Dev Tools**
`!ping`
`!source`
"

coloradoCasuals = 406973058042298378

testServer = 446823698754699275

tastefullyracist = (1..5).map { |n| "media/tastefully-racist/#{n}.gif" }

tastefullyRacistCommands = [:tastefullyracist, :tr]

helpCommands = [:commands, :help]

#Commands
bot.command helpCommands do |event|
  event.respond commands
  puts "Someone needed help".light_red
end

bot.command :joke do |event|
  event.respond File.readlines("jokes.db").sample.strip
  puts "Joke sent".green
end

bot.command :thanks do |event|
  event.respond "You're welcome!"
  puts "Someone said thanks".blue
end

bot.command :lol do |event|
  event.respond "( ° ͜ ʖ °)"
  puts "Someone laughed".red
end

bot.command :goodbot do |event|
  event.respond ":smile:"
  puts "Good bot".green
end

bot.command :badbot do |event|
  event.respond ":sob:"
  puts "Bad bot".red
end

bot.command :source do |event|
  event.respond "https://github.com/Dielerorn/jokebot"
  puts "Someone is looking at my source".blue
end

bot.command :whatdidyousay do |event|
  event.respond "What the fuck did you just fucking say about me, you little bitch? I'll have you know I graduated top of my class in the Navy Seals, and I've been involved in numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth, mark my fucking words. You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we speak I am contacting my secret network of spies across the USA and your IP is being traced right now so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven hundred ways, and that's just with my bare hands. Not only am I extensively trained in unarmed combat, but I have access to the entire arsenal of the United States Marine Corps and I will use it to its full extent to wipe your miserable ass off the face of the continent, you little shit. If only you could have known what unholy retribution your little \"clever\" comment was about to bring down upon you, maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You're fucking dead, kiddo."
  puts "Navy Seal".yellow
end

bot.command :tragedy do |event|
  event.respond "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It’s not a story the Jedi would tell you. It’s a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying. The dark side of the Force is a pathway to many abilities some consider to be unnatural. He became so powerful… the only thing he was afraid of was losing his power, which eventually, of course, he did. Unfortunately, he taught his apprentice everything he knew, then his apprentice killed him in his sleep. Ironic. He could save others from death, but not himself."
  puts "Did you ever hear the tragedy of Darth Plagueis The Wise?".red
end

bot.command :howtoplaystarcraft do |event|
  event.respond "git gud scrub"
  puts "A scrub got rekt".yellow
end

bot.command :howtogetredditkarma do |event|
  event.respond "repost"
  puts "A redditor got learnt".purple
end

bot.command :no do |event|
  event.respond "No."
  puts "No.".orange
end

bot.command :yes do |event|
  event.respond "Yes!"
  puts "Yes!".green
end

bot.command :yep do |event|
  event.attach_file(File.open('media/yep.gif'))
  puts "Yep".light_blue
end

bot.command :tricksy do |event|
  event.attach_file(File.open('media/gollum.gif'))
  puts "TRICKSY".light_blue
end

bot.command :wut do |event|
  event.attach_file(File.open('media/wut.gif'))
  puts "wut".light_green
end

bot.command tastefullyRacistCommands do |event|
  event.attach_file(File.open(tastefullyracist.sample))
  puts "Tasteful".light_yellow
end

bot.command :blackpeople do |event|
  event.respond "We all know what you were expecting, and frankly, im surprised at you..."
  puts "Yes!".green
end

bot.command :happybirthday do |event, name|
  event.respond "♪ Happy birthday to you! Happy birthday to you! Happy birthday dear #{name}! Happy birthday to you! ♪"
  puts "Birthday!".green
end

#Audio Commands

bot.command :say do |event, *text|
  text = text.join(" ")
  puts "I said \"#{text}\" ".green
  speech = ESpeak::Speech.new("#{text}", voice: "en-uk", :speed   => 120)
  speech.save("media/audio/speech.mp3")
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/speech.mp3')
  File.delete("media/audio/speech.mp3")
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :wow do |event|
  puts "WOW".yellow
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/wow.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end


bot.command :hellothere do |event|
  puts "Hello There!".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/hellothere.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :nice do |event|
  puts "Nice!".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/nice.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end


bot.command :ouch do |event|
  puts "Ouch!".yellow
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/ouch.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :doit do |event|
  puts "Dewwit".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/doit.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :oof do |event|
  puts "oof".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/oof.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :missionfailed do |event|
  puts "We'll Get Em Next Time".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/missionfailed.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :howrude do |event|
  puts "How Rude".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/howrude.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :omaewa do |event|
  puts "NANI?!?!".red
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/omaewa.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :goteem do |event|
  puts "GOTEEM".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/goteem.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :disappointment do |event|
  puts "My day is ruined".green
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/disappointment.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :answer do |event|
  puts "Answer the question!".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/answer.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :triple do |event|
  puts "Oh baby a triple!".red
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/triple.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :stupid do |event|
  puts "Stupid!".yellow
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/stupid.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

bot.command :damage do |event|
  puts "NOW THATS A LOTTA DAMAGE!".blue
  bot.voice_connect(event.user.voice_channel)
  event.voice.play_file('media/audio/damage.mp3')
  #Replace these with your own Server ID's
  bot.voice_destroy(coloradoCasuals)
  bot.voice_destroy(testServer)
end

# Dev Tools
bot.message(content: '!ping') do |event|
  # The `respond` method returns a `Message` object, which is stored in a variable `m`. The `edit` method is then called
  # to edit the message with the time difference between when the event was received and after the message was sent.
  m = event.respond('Pong!')
  m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

bot.ready do
  bot.game = "Bad Jokes 24/7"
end

bot.run
