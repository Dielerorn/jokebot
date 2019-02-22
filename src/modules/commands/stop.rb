module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Stop
    extend Discordrb::Commands::CommandContainer
    command :stop do |event|
      if event.user.id == 221416570142851082
        event.respond "Corbin cant do that"
      else
        Discordrb::LOGGER.info("Audio stopped")
        event.bot.voice_destroy(event.user.server)
        File.delete("data/media/music/song.mp3")
        event.bot.game = "Bad Jokes 24/7"
        progressbar.stop
        nil
      end
    end
  end
end
