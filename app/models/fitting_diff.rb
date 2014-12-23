class FittingDiff
  attr_reader :fitting, :pilots
  def initialize(fitting)
    @fitting = fitting
    @pilots = Pilot.includes(pilot_skills: :skill)
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

  def diffs
    pilots.map do |pilot|
      {
        pilot: pilot,
        fitting: requirements.map { |req| check_requirement(req, pilot) }
      }
    end
  end

  private

  def check_requirement(req, pilot)
    pilot_skill = pilot.pilot_skills.detect { |ps| ps.skill_id == req.skill_id }
    return false unless pilot_skill
    return false if pilot_skill.level < req.level
    return true if pilot_skill.level >= req.level
  end
end
