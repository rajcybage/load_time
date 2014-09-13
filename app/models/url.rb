class Url < ActiveRecord::Base
  attr_accessible :url_name, :threshold_value, :calculated_time

  belongs_to :user
end
