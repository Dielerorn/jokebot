module Bot::DiscordEvents
  module Clever
    #Configure Dialog Flow
    cleverbot = ApiAiRuby::Client.new(
        :client_access_token => ENV['DIALOGFLOWTOKEN']
    )
    extend Discordrb::EventContainer
    message do |event|
      if event.message.content.start_with? '!' #Dont run if the message is a command (Starts with !) Also I should use prefix_proc instead
        nil
      elsif $convo == true
        response = cleverbot.text_request "#{event.message.content}", :contexts => ['firstContext'], :resetContexts => true
        speech = response[:result][:fulfillment][:speech]
        event.respond speech
        Discordrb::LOGGER.info("I said #{speech}")
      else
        nil
      end
    end
  end
end
