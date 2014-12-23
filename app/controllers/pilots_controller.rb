class PilotsController < ApplicationController
  def show
    @pilot = Pilot.find(params[:id])
    skills = PilotSkill.includes(skill: :group).where(pilot: @pilot)
    @skills = skills.sort_by { |s| [s.skill.group.name, s.skill.name] }
  end

  def import_skills
    pilot = Pilot.find(params[:id])
    SkillImportJob.perform_later(pilot)
    redirect_to player_pilot_path(pilot.player, pilot)
  end
end
