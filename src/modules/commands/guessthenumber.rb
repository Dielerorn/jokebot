module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Guessthenumber
    extend Discordrb::Commands::CommandContainer
    command :guessthenumber do |event|
      Discordrb::LOGGER.info("Guess the number!")
      magic = rand(1..10)
      event.user.await(:guess) do |guess_event|
        guess = guess_event.message.content.to_i
        if guess == magic
          guess_event.respond ':white_check_mark: Well guessed!'
        else
          guess_event.respond(guess > magic ? ':x: Too high' : ':x: Too low')
          false
        end
      end
      event.respond 'Guess a number between 1 and 10: '
    end
  end
end
