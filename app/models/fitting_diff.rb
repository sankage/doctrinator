class FittingDiff
  attr_reader :fitting, :pilots
  def initialize(fitting)
    @fitting = fitting
    @pilots = Pilot.includes(pilot_skills: :skill).where(prime: true).order(:name)
  end

  def requirements
    fitting.requirements
  end

  def eft
    fitting.eft
  end

  def dna
    fitting.dna
  end

  def ship_id
    dna.split(":").first.to_i
  end

  def ship_name
    fitting.ship_name
  end

  def fitting_name
    "#{fitting.ship_name}—#{fitting.name}"
  end

  def diffs
    pilots.map do |pilot|
      if pilot.updated_at < 12.hours.ago || pilot.pilot_skills.size == 0
        SkillImportJob.perform_later(pilot)
      end
      {
        pilot: pilot,
        fitting_id: fitting.id,
        fitting: requirements.map { |req|
          check_requirement(req, pilot.pilot_skills)
        }
      }
    end
  end

  private

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
