module Bot::DiscordEvents
  # This event is processed each time a new user joins the server
  module NewUser
    extend Discordrb::EventContainer
    member_join do |event|
      Discordrb::LOGGER.info("A new member joined the server")
      colorado_casuals_server_id = 406973058042298380
      event.bot.channel(colorado_casuals_server_id).send_embed do |embed|
        embed.title = ':desktop: **Welcome to the Server!**'
        embed.colour = 'BF0A30'
        embed.add_field(name: "Here's a joke to start you off: ", value: File.readlines("data/jokes.db").sample.strip)
      end
      event.bot.channel(colorado_casuals_server_id).send_embed do |embed|
        embed.title = ':ok_hand: **We only have 2 rules here:**'
        embed.colour = 'FFD700'
        embed.add_field(name: "#1 Dont post memes in general", value: "(Do it anyway)")
        embed.add_field(name: "#2 Never stop **YEETING**", value: "Yeet is life")
      end
      event.bot.channel(colorado_casuals_server_id).send_embed do |embed|
        embed.title = ':grinning: **I am the JokeBot! Type !commands to see what I can do!**'
        embed.colour = '002868'
        embed.description = 'I do a lot more than just tell jokes. Check it out!'
      end
    end
  end
end
