module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Vote
    extend Discordrb::Commands::CommandContainer
    #This is for the vote command
      Emoji = {
        white_check_mark: "\u{2705}",
        x: "\u{274C}"
      }
    command :vote do |event, *topic|
      topic = topic.join(" ")
      Discordrb::LOGGER.info("We voted on #{topic}")
      event.message.delete #Delete the message that initiated this command for the sake of anonymity
      votingMessage = event.send_message("**#{topic}**")
      votingMessage.react(Emoji[:white_check_mark])
      votingMessage.react(Emoji[:x])
    end
  end
end
