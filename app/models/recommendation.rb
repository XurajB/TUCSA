class Recommendation < ActiveRecord::Base
  attr_accessible :cs_application_id, :email, :name, :status, :time_known_from, :time_known_to, :title
  
  belongs_to :cs_application
  has_one :rating
  
end
