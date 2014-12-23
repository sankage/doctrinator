class SkillImportJob < ActiveJob::Base
  queue_as :default

  def perform(pilot)
    PilotSkill.import_for_pilot(pilot)
  end
end
