module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Pause
    extend Discordrb::Commands::CommandContainer
    command :pause do |event|
      Discordrb::LOGGER.info("Audio paused")
      event.voice.pause
      progressbar.pause
      event.bot.game = "Music paused in #{channel.name}"
      nil
    end
  end
end
