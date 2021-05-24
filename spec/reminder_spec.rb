require_relative "../lib/reminder.rb"
require "date"

RSpec.describe ReminderWeekly do
  subject(:reminderweekly) do
    described_class.new("Test Weekly Reminder", "Owner", ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], [{ :hour => "09", :minute => "00", :second_of_day => 32400 }, { :hour => "10", :minute => "24", :second_of_day => 75600 }])
  end

  describe "#next_hours" do
    it "should return something if there is any reminder within 24 hours" do
      expect(reminderweekly.next_hours(24)).not_to eq([])
    end
  end

  describe "#next_hours" do
    it "should return nothing if no reminder within 24 hours" do
      expect((described_class.new("Test Weekly Reminder", "Owner", [], [])).next_hours(24)).to eq([])
    end
  end
end

