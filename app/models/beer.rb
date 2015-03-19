class Beer < ActiveRecord::Base
  belongs_to :user
  has_many :drinks

  def get_drinks
    data_rates = [[1.week.ago, 168, 10],
                  [3.days.ago, 72, 5],
                  [1.day.ago, 24, 2],
                  [6.hours.ago, 6, 1]]
    data_rates.each do |start, hours, count|
      drinks = self.drinks.where(created_at: start .. DateTime.now)
      @drink_hours = hours
      return drinks if drinks.count >= count
    end
  end

  def update_dry_at!
    drinks = get_drinks
    if drinks
      sum = drinks.sum("drinks.amount")
      rate = sum / @drink_hours
    # drinks per hour
    dph = self.weight / rate
    binding.pry
    self.update(dry_at: dph.floor.hours.from_now)
    end
  end
end
