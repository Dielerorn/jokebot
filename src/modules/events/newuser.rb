module Bot::DiscordEvents
  # This event is processed each time a new user joins the server
  module NewUser
    extend Discordrb::EventContainer
    member_join do |event|
      Discordrb::LOGGER.info("A new member joined the server")
      colorado_casuals_server_id = 406973058042298380
      event.bot.channel(colorado_casuals_server_id).send_message("**Welcome to the server! Heres a joke to start you off:**")
      event.bot.channel(colorado_casuals_server_id).send_message(File.readlines("data/jokes.db").sample.strip)
    end
  end
end
