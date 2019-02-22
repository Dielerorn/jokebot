module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Tastefullyracist
    extend Discordrb::Commands::CommandContainer
    #Change the 2nd number in parentheses for how many files there are
    tastefullyracist = (1..5).map { |n| "data/media/tastefully-racist/#{n}.gif" }
    tastefullyRacistCommands = [:tastefullyracist, :tr]
    command tastefullyRacistCommands do |event|
      Discordrb::LOGGER.info("Tasteful")
      event.attach_file(File.open(tastefullyracist.sample))
    end
  end
end
