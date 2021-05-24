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
      
      def next_hours(hours)
        start = Time.now
        final = start + (hours * 3600)
        reminders_to_take = @times_taken.filter do |time_stamp|
          if time_stamp[:hour].to_i > start.hour
            time_stamp = Time.new(start.year, start.month, start.day, time_stamp[:hour].to_i, time_stamp[:minute].to_i)
          else
            time_stamp = Time.new(start.year, start.month, start.day + 1, time_stamp[:hour].to_i, time_stamp[:minute].to_i)
          end
          @days_taken.include?(time_stamp.strftime("%A")) && time_stamp >= start && time_stamp <= final
        end
        reminders_to_take.each do |time|
          puts "\n#{@name} (#{owner})".colorize(:magenta) + " at " + "#{time[:hour]}:#{time[:minute]}".colorize(:yellow) + "\n"
        end
      end
end

