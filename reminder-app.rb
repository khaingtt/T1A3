require_relative ("lib/app.rb")
require_relative ("lib/reminder.rb")
require_relative ("lib/text.rb")

reminderapp = App.new

# This is just the welcome to the app then it calls the method to start the app
puts "#{AppText.title}".blue
prompt = TTY::Prompt.new
prompt.keypress(AppText.any_key)


reminderapp.run
