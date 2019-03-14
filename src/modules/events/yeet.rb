module Bot::DiscordEvents
  module Yeet
    extend Discordrb::EventContainer
    message do |event|
      if event.message.content.to_s.downcase.include? "yeet"
        Discordrb::LOGGER.info("I SAID YEET")
        event.respond("**YEET**")
      else
        nil
      end
    end
  end
end
