module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Guessthenumberhard
    extend Discordrb::Commands::CommandContainer
    command :guessthenumberhard do |event|
      Discordrb::LOGGER.info("Guess the number HARD")
      magic = rand(1..10)
      event.user.await(:guess) do |guess_event|
        guess = guess_event.message.content.to_i
        if guess == magic
          guess_event.respond ':white_check_mark: Well guessed!'
        else
          guess_event.respond ':x: Wrong! Guess again: '
          false
        end
      end
      event.respond 'Guess a number between 1 and 10: '
    end
  end
end
