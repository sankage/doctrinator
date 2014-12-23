class FittingDiff
  attr_reader :fitting, :pilots
  def initialize(fitting)
    @fitting = fitting
    @pilots = Pilot.includes(pilot_skills: :skill).order(:name)
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

  def ship_name
    fitting.ship_name
  end

  def fitting_name
    "#{fitting.ship_name}—#{fitting.name}"
  end

  def diffs
    pilots.map do |pilot|
      {
        pilot: pilot,
        fitting: requirements.map { |req| [req.skill_name, check_requirement(req, pilot)] }.to_h
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
