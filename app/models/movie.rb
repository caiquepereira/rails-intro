class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  @@all_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']

  def self.all_ratings
    @@all_ratings
  end

end
