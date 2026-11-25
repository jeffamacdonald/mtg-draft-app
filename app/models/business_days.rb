# Shared "is this a day off?" rule for timers and transfer portal deadlines:
# weekends and US (CA, observed) holidays.
module BusinessDays
  def self.off?(date_time)
    weekend?(date_time) || Holidays.on(date_time, :us_ca, :observed).present?
  end

  def self.weekend?(date_time)
    date_time.wday == 0 || date_time.wday == 6
  end
end
