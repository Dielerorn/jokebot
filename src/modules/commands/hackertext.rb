module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Hackertext
    extend Discordrb::Commands::CommandContainer
    #Letter replacements for hacker text
    replacements = {
      'A' => '4', 'a' => '4', 'E' => '3', 'e' => '3', 'G' => '6', 'g' => '6', 'L' => '1', 'l' => '1', 'O' => '0', 'o' => '0', 'S' => '5', 's' => '5', 'T' => '7', 't' => '7', 'I' => '!', 'i' => '!'}
    command :hackertext do |event, *text|
      Discordrb::LOGGER.info("Im in")
      text = text.join(" ")
      leettext = text.gsub(Regexp.union(replacements.keys), replacements)
      event.respond leettext
    end
  end
end
