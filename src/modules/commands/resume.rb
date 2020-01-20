module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Resume
    extend Discordrb::Commands::CommandContainer
    command :resume do |event|
      Discordrb::LOGGER.info("Audio continued")
      event.voice.continue
      event.bot.game = "Music in #{channel.name}"
      nil
    end
  end
end
