module Bot::DiscordEvents
  module Eggplant
    extend Discordrb::EventContainer
    message do |event|
      if event.message.user.id == 221416570142851082
        event.message.react "🍆"
      else
        nil
      end
    end
  end
end

#This reacts to all of Corbins messages with an eggplant

#221416570142851082
