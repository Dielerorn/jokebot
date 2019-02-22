# Gems
require 'discordrb'
require 'dotenv'
require 'espeak'
require 'youtube-dl.rb'
require "mediainfo"
require 'ruby-progressbar'
require 'usagewatch'
require 'mini_magick'
require 'open-uri'
require 'ostruct'

puts "WELCOME TO THE JOKEBOT"

# The main bot module.
module Bot
  # Load non-Discordrb modules
  Dir['src/modules/*.rb'].each { |mod| load mod }

  # Bot configuration
  Dotenv.load('data/.env')

  #Configure Logging without the gem
  start_time = Time.now.strftime("%F %R") # 2019-01-30 15:04
  logs_file = File.open("logs/#{start_time}-development.log", "w") # 2019-01-30 15:04-development.log
  Discordrb::LOGGER.streams << logs_file

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

  $voice_channel_error = "User must be in a voice channel"

  # Create the bot.
  # The bot is created as a constant, so that you
  # can access the cache anywhere.
  BOT = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: 446820464770154507, log_mode: :normal, prefix: prefix_proc

  # This class method wraps the module lazy-loading process of discordrb command
  # and event modules. Any module name passed to this method will have its child
  # constants iterated over and passed to `Discordrb::Commands::CommandBot#include!`
  # Any module name passed to this method *must*:
  #   - extend Discordrb::EventContainer
  #   - extend Discordrb::Commands::CommandContainer
  # @param klass [Symbol, #to_sym] the name of the module
  # @param path [String] the path underneath `src/modules/` to load files from
  def self.load_modules(klass, path)
    new_module = Module.new
    const_set(klass.to_sym, new_module)
    Dir["src/modules/#{path}/*.rb"].each { |file| load file }
    new_module.constants.each do |mod|
      BOT.include! new_module.const_get(mod)
    end
  end

  load_modules(:DiscordEvents, 'events')
  load_modules(:DiscordCommands, 'commands')

  #Handler for the restart command
  handler = BOT.ready do
    Discordrb::LOGGER.info("The bot is back up!")
    if ARGV[0] == "restart"
      BOT.send_message(ARGV[1], "Done!")
    end
    BOT.remove_handler(handler)
  end

  # Run the bot
  BOT.run
end
