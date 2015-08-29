class Pilot < ActiveRecord::Base
  belongs_to :api_key
  has_many :pilot_skills, dependent: :delete_all
  enum access_level: [:generic, :fc, :admin]

  def player
    api_key.player
  end
end
