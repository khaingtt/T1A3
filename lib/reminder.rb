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

class ReminderWeekly < Reminder
    attr_accessor :days_taken, :times_taken

    def initialize(name, owner, days_taken, times_taken)
        @name = name
        @owner = owner
        @days_taken = days_taken
        @times_taken = times_taken
    end
end

end