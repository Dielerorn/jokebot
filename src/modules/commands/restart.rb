module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Restart
    extend Discordrb::Commands::CommandContainer
    command :restart do |event|
      Discordrb::LOGGER.info("Restarting...")
      event.respond "Restarting..."
      event.bot.stop #If this doesnt work for some reason, use the constant Bot::BOT.stop
      exec "./run.sh restart #{event.channel.id}"
    end
  end
end
