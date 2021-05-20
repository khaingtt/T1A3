# This file contains all Reminder entry classes

require "date"
require "tod"
require "tod/core_extensions"
require "colorize"

class Reminder
  attr_accessor :name, :owner

  def initialize(name)
    @name = name
  end

end