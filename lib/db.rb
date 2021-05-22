# This file for classes and methods used to save the data
require_relative ("reminder.rb")

class Db
    @prompt = TTY::Prompt.new(symbols: { marker: "→" })
    def self.write_to_file(reminders)
        File.write("reminder.dat", Marshal.dump(reminders))
    end

    def self.read_from_file
        begin
            return [] unless File.exist?("reminder.dat")
            reminders = Marshal.load(File.read("reminder.dat"))
        rescue ArgumentError, TypeError
            puts "The data file is corrupted. ".colorize(:red) + "\nUnfortunately this is unrecoverable and any saved reminders have been lost. \nTo continue using this app, the file needs to be reinitialised.\n" + "(e.g. if you are a Marshal genius)".colorize(:light_black) + " you should choose yes. \nChoosing no will exit this app."
            @prompt.yes?("\nReinitialise data file? (no undo)".colorize(:yellow)) ? File.write("reminder.dat", Marshal.dump([])) : exit
            retry
        end
    end
end
