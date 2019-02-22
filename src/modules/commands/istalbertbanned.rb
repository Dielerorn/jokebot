module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Istalbertbanned
    extend Discordrb::Commands::CommandContainer
    command :istalbertbanned do |event|
      Discordrb::LOGGER.info("Checked if Talbert was banned from general")
      talbert = event.server.member(361438280757018624)
      general = event.bot.channel(406973058042298380) #General channel on the Colorado Casuals server
      if talbert.can_send_messages?(general)
        event.respond "Talbert is not banned from General...yet"
      else
        event.respond "Talbert is banned from General. F in the chat for our brave meme master"
      end
    end
  end
end
