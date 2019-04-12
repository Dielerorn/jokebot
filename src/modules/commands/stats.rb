module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Stats
    extend Discordrb::Commands::CommandContainer
    command :stats do |event|
      Discordrb::LOGGER.info("Someone checked the stats")
      store = YAML::Store.new("data/stats.yml")
      event << "Jokes told: #{store.transaction { store[:jokes_said] }}"
      event << "Times YEET has been said: #{store.transaction { store[:yeet_count] }}"
      event << "Times the Bot has been mentioned: #{store.transaction { store[:mentions] }}"
      event << "Songs played: #{store.transaction { store[:songs_played] }}"
      event << "Times pinged: #{store.transaction { store[:times_pinged] }}"
      event << "Times 100 has been rolled: #{store.transaction { store[:times_100_rolled] }}"
    end
  end
end
