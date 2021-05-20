# This file is the list of classes and methods used to run the app
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
end