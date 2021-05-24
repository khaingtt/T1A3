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

  def add_reminder_weekly(argv = false)
    clear
    titlebar
    puts "Add reminder taken on weekly schedule\n\n".colorize(:light_cyan)
    @reminders << ReminderWeekly.new(*reminder_weekly_input)
    Db.write_to_file(reminders)
    clear
    titlebar
    puts "Reminder added!\n\n"
    reminders.last.display_reminder
    continue
  end

  def edit_reminder_weekly(index)
    clear
    titlebar
    puts "Edit reminder\n".colorize(:light_cyan)
    puts "You are editing " + "#{reminders[index].name}".colorize(:magenta) + "\n\n"
    @reminders[index] = ReminderWeekly.new(*reminder_weekly_input)
    Db.write_to_file(reminders)
    clear
    titlebar
    puts "Reminder updated!\n\n"
    reminders[index].display_reminder
    continue
  end

  def edit_reminder
    display_all_reminders
    puts "Which entry would you like to edit?\n".colorize(:light_cyan)
    puts "Be careful, this is permanent!".colorize(:background => :red, :color => :white).blink
    choice = @prompt.ask("\nEnter a number to edit or q to cancel.")

    if choice.nil?
      continue
      reminders_menu
    elsif choice.upcase == "Q"
      puts "\n Edit cancelled.".colorize(:green)
      continue
      reminders_menu
    elsif choice.is_integer?
      if choice.to_i >= 0 && reminders[choice.to_i - 1].nil? == false
          edit_reminder_weekly(choice.to_i - 1)
      else
        puts "\nSelected entry does not exist.".colorize(:red)
        continue
        reminders_menu
      end
    else
      puts "\nInvalid input, edit cancelled.".colorize(:red)
      continue
      reminders_menu
    end
  end

  def delete_reminder
    display_all_reminders
    puts "Which entry would you like to delete?\n".colorize(:light_cyan)
    puts "Be careful, this is permanent!".colorize(:background => :red, :color => :white).blink
    choice = @prompt.ask("\nEnter a number to delete or q to cancel.")
    if choice.is_integer?
      if choice.to_i >= 0 && reminders[choice.to_i - 1].nil? == false
        if @prompt.yes?("Are you sure?")
          reminders.delete_at(choice.to_i - 1)
          clear
          titlebar
          puts "\nReminder deleted!"
          continue
        else
          puts "\n Delete cancelled.".colorize(:green)
          continue
          reminders_menu
        end
      else
        puts "\nSelected entry does not exist.".colorize(:red)
        continue
        reminders_menu
      end
    else
      if choice.upcase == "Q"
        puts "\n Delete cancelled.".colorize(:green)
        continue
        reminders_menu
      else
        puts "\nInvalid input, delete cancelled.".colorize(:red)
        continue
        reminders_menu
      end
    end
  end

  def reminders_menu(argv = false)
    loop do
      clear
      titlebar
      puts "View, edit or delete existing reminders\n".colorize(:light_cyan)
      choices = [
        { name: "View all reminder entries", value: -> {
          display_all_reminders
          continue
        } },
        { name: "Edit a reminder entry", value: -> {
          edit_reminder
          Db.write_to_file(reminders)
          } },
        { name: "Delete a reminder entry", value: -> {
          delete_reminder
          Db.write_to_file(reminders)
          } },
        { name: "Back", value: -> {
          if argv
            exit
          else
            clear
            main_menu
          end
        } },
      ]
      choice = @prompt.select("Please select from the following options:\n", choices, help: "(Choose using ↑/↓ arrow keys, press Enter to select)", show_help: :always)
    end
  end

  def time_input
    times = []
    time_taken = ""

    loop do
      input = @prompt.ask("What time of day do you want to set this reminder?", required: :true)
      if Tod::TimeOfDay.parsable?(input)
        time_taken = Tod::TimeOfDay.parse(input)
        break
      else
        puts "Invalid input. Please enter a time (e.g. 1600, 4pm, 4:00)\n".colorize(:red)
      end
    end
    times.push({ hour: time_taken.hour.to_s.rjust(2, "0"), minute: time_taken.minute.to_s.rjust(2, "0"), second_of_day: time_taken.second_of_day })
    return times
  end

  def reminder_week(argv = false)
    clear
    titlebar
    puts "---------- 1 Week Schedule ----------\n".colorize(:light_cyan)
    reminders_day = {
      "Sunday" => [],
      "Monday" => [],
      "Tuesday" => [],
      "Wednesday" => [],
      "Thursday" => [],
      "Friday" => [],
      "Saturday" => [],
    }
    today = Date.today
    reminders.each do |remind|
        remind.days_taken.each do |day|
          reminders_day[day] << remind
        end
    end
    schedule_1week = reminders_day.to_a.rotate(Date.today.wday)
    schedule_1week.each do |day|
      header = "\n----- #{day.first} -----"
      puts header.colorize(:yellow)
      if day.last == []
        puts "\nNo reminders\n"
      else
        day.last.each(&:display_reminder_short)
      end
      header.length.times do
        print "-".colorize(:yellow)
      end
      puts "\n\n"
    end
    continue
    if argv
      exit
    else
      clear
      main_menu
    end
  end

  def reminder_day(argv = false)
    clear
    titlebar
    puts "---------- Short Schedule ----------\n".colorize(:light_cyan)
    reminders.each do |remind|
      remind.next_hours(24)
    end
    continue
    exit if argv
    clear
    main_menu
  end

end