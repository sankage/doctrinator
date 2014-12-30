class ApiKey < ActiveRecord::Base
  belongs_to :player
  has_many :pilots, dependent: :destroy
  enum status: [:correct, :incorrect, :expired, :no_access]

  def status_text
    case status
    when "correct" then "valid"
    when "incorrect" then "invalid"
    else status
    end
  end
end
