=begin

#This event requires the gem 'api-ai-ruby' (Googles DialogFlow gem)
#Its currently disabled because the gem was bugged and could not properly install

module Bot::DiscordEvents
  module Yeet
    extend Discordrb::EventContainer
    message do |event|
      sessions = {}
      if event.server && !event.author.roles.any?
        str = "#{event.channel.id}_CLIENT_TOKEN"
        if ENV[str]
          if !sessions[event.channel.id]
            sessions[event.channel.id] = ApiAiRuby::Client.new( :client_access_token => ENV[str] )
          end
          response = sessions[event.channel.id].text_request event.message.content[0,255]
          speech = response[:result][:fulfillment][:speech]
          if speech && !speech.empty?
            event.channel.start_typing
            sleep 1
            event.respond "#{speech}"
          end
        end
      end
    end
  end
end


=end
