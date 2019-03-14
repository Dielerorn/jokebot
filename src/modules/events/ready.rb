module Bot::DiscordEvents
  module Ready
    extend Discordrb::EventContainer
    ready do |event|
      event.bot.game = "Bad Jokes 24/7"
    end
  end
end
