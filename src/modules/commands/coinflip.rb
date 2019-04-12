module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Coinflip
    extend Discordrb::Commands::CommandContainer
    command :coinflip do |event|
      %w(Heads Tails).sample
    end
  end
end
