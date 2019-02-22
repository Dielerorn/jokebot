module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Nickname
    extend Discordrb::Commands::CommandContainer
    command :nickname do |event, *name|
      botUser = event.server.member(event.bot.profile)
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
  end
end
