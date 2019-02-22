module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Roll
    extend Discordrb::Commands::CommandContainer
    command :roll do |event|
      rollNumber = rand(1..100)
      rollUser = event.user.username
      Discordrb::LOGGER.info("#{rollUser} rolled a #{rollNumber}")
      if rollNumber == 100
        event.respond "#{rollUser} rolled a :100:"
      else
      event.respond "#{rollUser} rolled a #{rollNumber}!"
      end
    end
  end
end
