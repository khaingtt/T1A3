# This file is the list of classes and methods used to run the app
require "tty-prompt"
require "tod"
require "io/console"
require "date"
require "time"
require "colorize"
require_relative ("reminder.rb")
require_relative ("db.rb")
require_relative ("text.rb")
class App
  attr_accessor :reminders

  def initialize
    @prompt = TTY::Prompt.new(symbols: { marker: "→" })
    @reminders = Db.read_from_file
  end

  def run
    loop do
      clear
      main_menu
    end
  end

  def main_menu
    titlebar
    choices = [
      { name: "Add new reminders", value: -> { add_reminder_weekly } },
      { name: "View, edit or delete existing reminders", value: -> { reminders_menu } },
      { name: "Show 1 week schedule", value: -> { reminder_week } },
      { name: "Show next 24 hour schedule", value: -> { reminder_day } },
      { name: "Exit", value: -> {
        clear
        titlebar
        puts "#{AppText.exit}".blue
        #puts "Thanks for using Khai Reminder App!"
        sleep(2)
        clear
        Db.write_to_file(reminders)
        exit
      } },
    ]
    choice = @prompt.select("Please choose from the following options.\n\n", choices, help: "(Choose using ↑/↓ arrow keys, press Enter to select)", show_help: :always, per_page: 10)
  end

  def titlebar
    puts "-------------- Khai Reminder App --------------\n".colorize(:color => :yellow).underline
  end
#Reminder menu for the app
  def reminder_weekly_input
    reminder_name = @prompt.ask("What is the name of the reminder?", required: :true)
    reminder_owner = @prompt.ask("Who is this reminder for?", required: :true)
    choices = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    reminder_days_taken = @prompt.multi_select("Which days of the week do you take it?", choices, per_page: 7, help: "\n(Press ↑/↓ arrow keys to navigate, Space to select and Enter to continue)", show_help: :always, min: 1)
    reminder_times_taken = time_input
    return reminder_name, reminder_owner, reminder_days_taken, reminder_times_taken
  end
  
end