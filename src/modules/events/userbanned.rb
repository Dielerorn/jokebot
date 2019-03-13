module Bot::DiscordEvents
  # This event is processed each time a new user joins the server
  module UserBanned
    extend Discordrb::EventContainer
    user_ban do |event|
      Discordrb::LOGGER.info("A user was banned from the server")
      colorado_casuals_server_id = 406973058042298380
      event.bot.channel(colorado_casuals_server_id).send_message("**OOOOOOHHHHH! GET BANNED SON**")
    end
  end
end
