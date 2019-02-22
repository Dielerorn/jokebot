module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Deepfry
    extend Discordrb::Commands::CommandContainer
    #Change the 2nd number in parentheses for how many files there are
    emojis = (1..19).map { |n| "data/media/emojis/#{n}.png" }
    command :deepfry do |event|
      Discordrb::LOGGER.info("I deep fried the most recent image")
      #Find the recent image by checking the channel history and filtering it
      recent_messages = event.channel.history(15) #Only search the last 15 messages in the channel
      image_message = recent_messages.find { |m| m.attachments.any?(&:image?) }
      attachment = image_message.attachments.find(&:image?)
      #Download the image
      download = open(attachment.url)
      IO.copy_stream(download, 'data/media/temp/deepfry.jpg')
      #Deepfry the image
      processing_message = event.send_message("Processing...")
      image = MiniMagick::Image.new("data/media/temp/deepfry.jpg")
      image_width = image.dimensions[0]
      image_height = image.dimensions[1]
      rand(1..4).times do #This bLock composites the emojis, randomizing between 1-4 emojis added
        chosen_emoji = MiniMagick::Image.open("#{emojis.sample}")
        chosen_emoji_scaled = chosen_emoji.resize "#{image_width / rand(4..8)}x#{image_height / rand(4..8)}"
        chosen_emoji_scaled.write "data/media/temp/emoji.png"
        result = image.composite(MiniMagick::Image.new("data/media/temp/emoji.png")) do |c|
          c.compose "Over"
          c.geometry "+#{image.dimensions[0] / rand(1..8)}+#{image.dimensions[1] / rand(1..8)}"
        end
        result.write "data/media/temp/deepfry.jpg"
      end
      image.combine_options do |b|
        b.quality "5"
        rand(4..16).times { b.contrast }
        4.times {b.noise.+ "Gaussian"}
        b.colorize "15,0,0"
        b.brightness_contrast "-6"
        b.distort("shepards", "#{rand(1..250)},#{rand(1..250)} #{rand(1..250)},#{rand(1..250)} #{rand(1..250)},#{rand(1..250)} #{rand(1..250)},#{rand(1..250)}")
      end
      #Send the final version and delete the file
      processing_message.delete
      event.attach_file(File.open('data/media/temp/deepfry.jpg'))
      File.delete("data/media/temp/deepfry.jpg")
      File.delete("data/media/temp/emoji.png")
      nil
    end
  end
end
