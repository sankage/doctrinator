class Pilot < ActiveRecord::Base
  belongs_to :api_key
  has_many :pilot_skills

  def player
    api_key.player
  end
end
