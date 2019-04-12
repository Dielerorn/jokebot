module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Convo
    extend Discordrb::Commands::CommandContainer
    command :convo do |event, value|
      convo_on_array = ["I can talk now!", "WHATS UP DOODS", "Guess who's back, back again", "Ayyyyy!", "Talking has been enabled!", "Jokebot has joined the chat"]
      convo_off_array = ["Talking has been disabled", "Alright...I see how it is", "PEACE OUT Y'ALL", "https://tenor.com/view/arnold-schwarzenegger-the-terminator-ill-be-back-gif-4367793", "Jokebot has left the chat"]
      Discordrb::LOGGER.info("Talk was set to #{value}")
      if value.downcase == "on"
        $convo = true
        event.respond convo_on_array.sample.strip
      elsif value.downcase == "off"
        $convo = false
        event.respond convo_off_array.sample.strip
      else
        event.respond "This command requires a value. Try `!talk on` or `!talk off`"
      end
    end
  end
end
