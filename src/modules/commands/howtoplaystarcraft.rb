module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Howtoplaystarcraft
    extend Discordrb::Commands::CommandContainer
    command :howtoplaystarcraft do |event|
      Discordrb::LOGGER.info("A scrub got rekt")
      event.respond "git gud scrub"
    end
  end
end
