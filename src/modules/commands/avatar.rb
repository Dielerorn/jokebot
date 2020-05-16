module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Avatar
    extend Discordrb::Commands::CommandContainer
    command :avatar do |event, url|
      if url =~ URI::regexp
        Discordrb::LOGGER.info("Avatar changed to #{url}")
        event.bot.profile.avatar = open(url)
        event.respond "Avatar set!"
      elsif url == nil
        event.respond "Avatar reset to default"
        event.bot.profile.avatar = open('https://i.imgur.com/WuY4gva.png')
      else
        event.respond "Not a valid URL"
      end
    end
  end
end
