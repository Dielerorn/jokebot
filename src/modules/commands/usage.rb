module Bot::DiscordCommands
  # Document your command
  # in some YARD comments here!
  module Usage
    extend Discordrb::Commands::CommandContainer
    usw = Usagewatch
    command :usage do |event|
      Discordrb::LOGGER.info("Somebody checked the system resource usage")
      event << "#{usw.uw_diskused} Gigabytes Disk Used"
      event << "#{usw.uw_cpuused} CPU Used"
      event << "#{usw.uw_tcpused} TCP Connections Used"
      event << "#{usw.uw_udpused} UDP Connections Used"
      event << "#{usw.uw_memused} Active Memory Used"
      event << "#{usw.uw_load} Average System Load Of The Past Minute"
      event << "#{usw.uw_bandrx} Mbit/s Current Bandwidth Received"
      event << "#{usw.uw_bandtx} Mbit/s Current Bandwidth Transmitted"
      event << "#{usw.uw_diskioreads} Current Disk Reads Completed"
      event << "#{usw.uw_diskiowrites} Current Disk Writes Completed"
      event << "Top Ten Processes By CPU Consumption:"
      event << usw.uw_cputop
      event << "Top Ten Processes By Memory Consumption:"
      event << usw.uw_memtop
    end
  end
end
