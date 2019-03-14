module Bot::DiscordEvents
  module DeleteWithReact
    extend Discordrb::EventContainer
    reaction_add do |event|
      if event.message.from_bot? && event.message.reactions.key?("❌")
        event.message.delete
      end
    end
  end
end
