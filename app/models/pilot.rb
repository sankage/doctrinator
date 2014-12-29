class Pilot < ActiveRecord::Base
  belongs_to :api_key
  has_many :pilot_skills, dependent: :delete_all

  def player
    api_key.player
  end
end
