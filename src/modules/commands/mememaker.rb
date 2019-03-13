module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Mememaker
    extend Discordrb::Commands::CommandContainer
    command :mememaker do |event|
      Discordrb::LOGGER.info("Someone made a meme with the most recent image")
      #Find the recent image by checking the channel history and filtering it
      begin
      recent_messages = event.channel.history(50) #Only search the last 50 messages in the channel
      image_message = recent_messages.find { |m| !m.from_bot? && m.attachments.any?(&:image?) }
      attachment = image_message.attachments.find(&:image?)
      rescue
        Discordrb::LOGGER.error("No images found")
        event.respond "No images found"
      end
      #Download the image
      begin
      download = open(attachment.url)
      IO.copy_stream(download, 'data/media/temp/meme.jpg')
      rescue
        Discordrb::LOGGER.error("There was an error downloading the image")
        event.respond "There was an error downloading the image"
      end
      #Make it a meme
      event.respond "**Top Text:**"
      top_text = event.message.await!(timeout: 120)
      if top_text
        top_text = top_text.content.to_s
      else
        event.respond "Command timed out"
      end
      event.respond "**Bottom Text:**"
      bottom_text = event.message.await!(timeout: 120)
      if bottom_text
        bottom_text = bottom_text.content.to_s
      else
        event.respond "Command timed out"
      end
      processing_message = event.send_message("Processing...")
      begin
        image = MiniMagick::Image.new("data/media/temp/meme.jpg")
        image_width = image.dimensions[0]
        image_height = image.dimensions[1]
        pointsize = image_width / 17
        image.combine_options do |c|
          c.gravity 'Center'
          c.pointsize "#{pointsize}"
          c.font "Impact"
          c.draw "text 0,#{image_height / -2.2} '#{top_text}'"
          c.fill 'white'
          c.stroke "black"
          c.strokewidth "#{pointsize / 25}"
          c.draw "text 0,#{image_height / 2.2} '#{bottom_text}'"
          c.fill 'white'
          c.stroke "black"
          c.strokewidth "#{pointsize / 25}"
        end
      rescue
        Discordrb::LOGGER.error("There was an error modifying the image")
      end
      #Send the final version and delete the file
      processing_message.delete
      event.attach_file(File.open('data/media/temp/meme.jpg'))
      File.delete("data/media/temp/meme.jpg")
      nil
    end
  end
end
