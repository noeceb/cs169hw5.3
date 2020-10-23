class Movie < ActiveRecord::Base
  def self.with_ratings(rating_list)
    if rating_list.empty?
      return where(rating: self.all_ratings)
    end
    return where(rating: rating_list)
  end
  
  def self.all_ratings
    return ['G', 'PG', 'PG-13', 'R']
  end
end
