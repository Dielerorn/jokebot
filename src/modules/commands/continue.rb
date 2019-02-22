module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Continue
    extend Discordrb::Commands::CommandContainer
    command :continue do |event|
      Discordrb::LOGGER.info("Audio continued")
      event.voice.continue
      event.bot.game = "Music in #{channel.name}"
      nil
    end
  end
end
