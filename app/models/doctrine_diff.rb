class DoctrineDiff
  attr_reader :doctrine, :pilots, :fittings
  def initialize(doctrine)
    @doctrine = doctrine
    @fittings = doctrine.fittings
    @pilots = Pilot.includes(pilot_skills: :skill).order(:name)
  end

  def doctrine_name
    doctrine.name
  end

  def fitting_names
    fittings.map do |fitting|
      "#{fitting.ship_name}—#{fitting.name}"
    end
  end

  def diffs
    pilots.map do |pilot|
      if pilot.updated_at < 12.hours.ago || pilot.pilot_skills.size == 0
        SkillImportJob.perform_later(pilot)
      end
      {
        pilot: pilot,
        fittings: fitting_requirements(pilot)
      }
    end
  end

  private

  def fitting_requirements(pilot)
    fittings.map do |fitting|
      fitting.requirements.map { |req|
        [req.skill_name, check_requirement(req, pilot.pilot_skills)]
      }.to_h.merge({ id: fitting.id })
    end
  end

  def check_requirement(req, pilot_skills)
    pilot_skill = pilot_skills.detect { |ps| ps.skill_id == req.skill_id }
    return false unless pilot_skill
    return false if pilot_skill.level < req.level
    return true if pilot_skill.level >= req.level
  end
end
