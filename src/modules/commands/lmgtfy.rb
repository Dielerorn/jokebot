module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module LMGTFY
    extend Discordrb::Commands::CommandContainer
    command :lmgtfy do |event, *text|
      Discordrb::LOGGER.info("Let me google '#{text}' for you...")
      event.respond "http://lmgtfy.com/?q=#{text.join('+')}"
    end
  end
end
