module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Logs
    extend Discordrb::Commands::CommandContainer
    command :logs do |event|
      log_files = Dir["logs/*"].reverse #Reverse the array so that the latest log files are listed first
      log_number = 0
      Discordrb::LOGGER.info("Someone downloaded the log files")
        event.respond "**Which log would you like to see?**"
        log_files.each { #List the available log files
          |log|
          event.respond "`#{log_number}: #{log}`"
          log_number += 1
          break if log_number == 3 #Only show 3 log files so that we dont get into trouble with the rate limiter
        }
        event.user.await(:log_choice) do |log_choice_event|
          choice = log_choice_event.message.content.to_i
          Discordrb::LOGGER.info("Log number #{choice} was chosen")
          event.respond "**Sending Log File #{choice}...**"
          log_choice_event.channel.send_file(File.open(log_files[choice]))
        end
        nil
    end
  end
end
