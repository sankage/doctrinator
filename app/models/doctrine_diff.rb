class DoctrineDiff
  attr_reader :doctrine, :pilots, :fittings
  def initialize(doctrine)
    @doctrine = doctrine
    @fittings = doctrine.fittings.sort_by { |fit| fit.full_name }
    @pilots = Pilot.includes(pilot_skills: :skill).order(:name)
  end

  def doctrine_name
    doctrine.name
  end

  def fitting_names
    fittings.map(&:full_name)
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
      {
        fitting_id: fitting.id,
        fitting: fitting.requirements.map { |req|
          check_requirement(req, pilot.pilot_skills)
        }
      }
    end
  end

  def check_requirement(req, pilot_skills)
    pilot_skill = pilot_skills.detect { |ps| ps.skill_id == req.skill_id }
    {
      name: req.skill_name,
      diff: pilot_skill.nil? ? -9 : pilot_skill.level - req.level,
      pilot_skill_level: pilot_skill.nil? ? 0 : pilot_skill.level,
      requirement_level: req.level
    }
  end
end
