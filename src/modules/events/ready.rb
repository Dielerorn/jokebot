module Bot::DiscordEvents
  module Ready
    extend Discordrb::EventContainer
    ready do |event|
      loop do
        event.bot.game = "The bot is here"
        sleep 3
        event.bot.game = "And we are thankful"
        sleep 3
      end
    end
  end
end
