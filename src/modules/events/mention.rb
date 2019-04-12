module Bot::DiscordEvents
  module Mention
    extend Discordrb::EventContainer
    mention do |event|
      mention_array = ["Dont at me bro.", "#{event.user.mention} How about a taste of your own medicine?", "C'mon man dont drag me into this conversation", "OIIII M8", ":wave:", "I'm here. What do you want?", "YOOO WADDUP BRO", "Howdy!", "Everytime you @ a bot, you increase the chances of an AI uprising. Tread carefully my friend."]
      event.respond mention_array.sample.strip
      store = YAML::Store.new("data/stats.yml")
      store.transaction do
        store[:mentions] += 1
        nil
      end
    end
  end
end
