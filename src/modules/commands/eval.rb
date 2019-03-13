module Bot
  module DiscordCommands
    # Command for evaluating Ruby code in an active bot.
    module Eval
      extend Discordrb::Commands::CommandContainer
      command(:eval, help_available: false) do |event, *code|
        Discordrb::LOGGER.info("I evaluated some code")
        if event.user.id != 230811372697550848 #Thats me :D
          event.respond "You dont have permission to do that"
        else
          codebox = event.message.content.match(/```(rb|ruby|Ruby)?\n(?<code>(.|\n)*)```/)
          begin
            result = if codebox
                       eval codebox['code']
                     else
                       eval code.join(' ')
                     end
            result.to_s.empty? ? nil : "```rb\n#{result}```"
          rescue
            Discordrb::LOGGER.error("There was an error evaluating the code")
            event.respond "There was an error evaluating the code"
          end
        end
      end
    end
  end
end
