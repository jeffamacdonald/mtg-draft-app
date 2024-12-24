Holidays.between(Date.today, Date.today + 1.years, :us) # without this, standard holidays are being overwritten by the next line
Holidays.load_custom("custom_holidays.yml")