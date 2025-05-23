require 'rails_helper'

RSpec.describe TimerCalculator, type: :model do
  describe "#calculate_target_end" do
    context "when pick starts on a weekend" do
      it "target end date time is timer minutes past 9am on monday" do
        # saturday
        travel_to Time.new(2024, 05, 11, 12, 00, 00, "-07:00") do
          pick_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)")
          timer_minutes = 120
          expected_end_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)").beginning_of_day + 2.days + 11.hours

          expect(described_class.new(pick_time, timer_minutes).calculate_target_end).to eq expected_end_time
        end
      end
    end

    context "when pick starts on thanksgiving" do
      it "target end date time is timer minutes past 9am on monday" do
        # thursday, duh
        travel_to Time.new(2024, 11, 28, 12, 00, 00, "-08:00") do
          pick_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)")
          timer_minutes = 120
          expected_end_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)").beginning_of_day + 4.days + 11.hours

          expect(described_class.new(pick_time, timer_minutes).calculate_target_end).to eq expected_end_time
        end
      end
    end

    context "when pick is on a non-holiday weekday" do
      context "when pick starts before 9am" do
        it "target end date time is timer minutes past 9am today" do
          # tuesday
          travel_to Time.new(2024, 05, 7, 7, 00, 00, "-07:00") do
            pick_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)")
            timer_minutes = 120
            expected_end_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)").beginning_of_day + 11.hours

            expect(described_class.new(pick_time, timer_minutes).calculate_target_end).to eq expected_end_time
          end
        end
      end

      context "when pick starts after 7pm" do
        it "target end date time is timer minutes past 9am tomorrow" do
          # thursday
          travel_to Time.new(2024, 05, 9, 20, 00, 00, "-07:00") do
            pick_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)")
            timer_minutes = 120
            expected_end_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)").beginning_of_day + 1.day + 11.hours

            expect(described_class.new(pick_time, timer_minutes).calculate_target_end).to eq expected_end_time
          end
        end
      end

      context "when pick is in the middle between 9 and 7" do
        it "target end date time is timer minutes past pick time" do
          # tuesday
          travel_to Time.new(2024, 05, 7, 12, 25, 00, "-07:00") do
            pick_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)")
            timer_minutes = 120
            expected_end_time = pick_time + 2.hours

            expect(described_class.new(pick_time, timer_minutes).calculate_target_end).to eq expected_end_time
          end
        end
      end

      context "when pick is slightly before 7" do
        it "target end date time is timer minutes minus time until 6pm past 8am tomorrow" do
          # tuesday
          travel_to Time.new(2024, 05, 7, 18, 25, 00, "-07:00") do
            pick_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)")
            timer_minutes = 120
            expected_end_time = Time.zone.now.in_time_zone("Pacific Time (US & Canada)").beginning_of_day + 1.day + 10.hours + 25.minutes

            expect(described_class.new(pick_time, timer_minutes).calculate_target_end).to eq expected_end_time
          end
        end
      end
    end
  end
end
