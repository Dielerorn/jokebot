module Bot::DiscordEvents
  module Yeet
    extend Discordrb::EventContainer
    message do |event|
      if event.message.content.to_s.downcase.include? "yeet"
        Discordrb::LOGGER.info("I SAID YEET")
        event.respond("**YEET**")
        store = YAML::Store.new("data/stats.yml")
        store.transaction do
          store[:yeet_count] += 1
          nil
        end
      else
        nil
      end
    end
  end
end
