module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Howtogetredditkarma
    extend Discordrb::Commands::CommandContainer
    command :howtogetredditkarma do |event|
      Discordrb::LOGGER.info("A redditor got learnt")
      event.respond "repost"
    end
  end
end
