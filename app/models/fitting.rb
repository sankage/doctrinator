class Fitting < ActiveRecord::Base
  def self.from_dna(dna, name = "")
    parsed_dna = DNAParser.new(dna: dna, name: name)
    new(name: name, ship_name: parsed_dna.ship_name, dna: dna, eft: parsed_dna.eft, requirement_dna: parsed_dna.requirement_dna)
  end

  def self.from_eft(eft_string)
    parsed_eft = EFTParser.new(eft: eft_string)
    new(name: parsed_eft.name, ship_name: parsed_eft.ship_name, dna: parsed_eft.dna, eft: parsed_eft.eft, requirement_dna: parsed_eft.requirement_dna)
  end

  def requirements
    @requirements ||= begin
      skills = requirement_dna.split(":").map { |skill_level|
        skill_level.split(";").map(&:to_i)
      }
      Requirement.create_from_static_array(skills)
    end
  end

  def full_name
    "#{ship_name}—#{name}"
  end
end
