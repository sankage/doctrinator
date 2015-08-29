class PilotsController < ApplicationController
  before_action :logged_in_admin

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

  def mark_prime
    pilot = Pilot.find(params[:id])
    pilot.toggle!(:prime)
    redirect_to player_pilot_path(pilot.player, pilot)
  end

  def make_generic
    pilot = Pilot.find_by(id: params[:id])
    pilot.generic!
    redirect_to player_pilot_path(pilot.player, pilot)
  end

  def make_fc
    pilot = Pilot.find_by(id: params[:id])
    pilot.fc!
    redirect_to player_pilot_path(pilot.player, pilot)
  end

  def make_admin
    pilot = Pilot.find_by(id: params[:id])
    pilot.admin!
    redirect_to player_pilot_path(pilot.player, pilot)
  end
end
