module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Region
    extend Discordrb::Commands::CommandContainer
    command(:region, chain_usable: false, description: "Gets the region the server is stationed in.") do |event|
      Discordrb::LOGGER.info("Getting Region")
      event.server.region
    end
  end
end
