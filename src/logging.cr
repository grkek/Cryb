require "colorize"

module Logging

  def self.info(info : String)
    puts info.colorize(:white)
  end

  def self.warning(warning : String)
    puts warning.colorize(:yellow)
  end

  def self.error(error : String)
    puts error.colorize(:red)
  end

  def self.errorgets(error : String) : String | Nil
    puts "#{error.colorize(:red)} "
    gets
  end

  def self.fatal(error : String)
    puts error.colorize(:red)
  end

  def self.motd(motd : String)
    puts motd.colorize(:green)
  end
  
end