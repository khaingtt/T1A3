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

    def display_reminder
        puts "Reminder name:".colorize(:cyan)
        puts "#{@name}".colorize(:light_cyan)
        puts "Owner: ".colorize(:light_magenta)
        puts "#{@owner}"
        puts "Days taken: ".colorize(:light_magenta)
        @days_taken.each do |day|
          puts day
        end
        puts "Times taken: ".colorize(:light_magenta)
        @times_taken.each do |time|
          puts "#{time[:hour]}:#{time[:minute]}"
        end
      end
    
      def display_reminder_short
        puts "\nReminder name: ".colorize(:cyan)
        puts "#{@name}".colorize(:light_cyan)
        puts "Owner: ".colorize(:light_magenta)
        puts "#{@owner}"
        puts "Times taken: ".colorize(:light_magenta)
        @times_taken.each do |time|
          puts "#{time[:hour]}:#{time[:minute]}\n"
        end
        puts "\n"
      end
      
end

end