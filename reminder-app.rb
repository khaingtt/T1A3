require_relative ("lib/app.rb")
require_relative ("lib/reminder.rb")
require_relative ("lib/text.rb")

reminderapp = App.new

# This is just the welcome to the app then it calls the method to start the app
puts "#{AppText.title}".blue
prompt = TTY::Prompt.new
prompt.keypress(AppText.any_key)

case ARGV[0]
when nil
when "--add"
  reminderapp.add_reminder_weekly(true)
when "--edit"
  reminderapp.reminders_menu(true)
when "--week"
  reminderapp.reminder_week(true)
when "--day"
  reminderapp.reminder_day(true)
when "--help"
  puts "Khai reminder app is a CLI app to help people remember and manage their reminders."
  puts "\n"
  puts "Without arguments, this menu system will be displayed and all features can be used this way."
  puts "If you prefer, most functionality can be accessed using command line arguments."
  puts "\nArguments:"
  puts "--add       - add a new reminder"
  puts "--edit      - show view/edit/delete reminders menu"
  puts "--week      - print a 1 week reminders"
  puts "--day       - print next 24 hour reminders"
  puts "--help      - show help and command line arguments"
  exit
else
  puts "Invalid argument."
  puts "\nArguments:"
  puts "--add       - add a new reminder"
  puts "--edit      - show view/edit/delete reminders menu"
  puts "--week      - print a 1 week reminders"
  puts "--day       - print next 24 hour reminders"
  puts "--help      - show help and command line arguments"
  exit
end

reminderapp.run
