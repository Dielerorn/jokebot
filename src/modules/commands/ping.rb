module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Ping
    extend Discordrb::Commands::CommandContainer
    command :ping do |event|
      Discordrb::LOGGER.info("Ping!")
      # The `respond` method returns a `Message` object, which is stored in a variable `m`. The `edit` method is then called
      # to edit the message with the time difference between when the event was received and after the message was sent.
      m = event.respond('Pong!')
      m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
    end
  end
end
