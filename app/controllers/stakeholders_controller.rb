# frozen_string_literal: true

class StakeholdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stakeholder, only: [ :show, :edit, :update, :destroy ]

  def index
    # @stakeholders = current_user.account.stakeholders.active.includes(:account)

    @stakeholders = Stakeholders::Base.all

    @stakeholders = filter_stakeholders(@stakeholders) if params[:filter].present?
    @stakeholders = sort_stakeholders(@stakeholders) if params[:sort].present?
  end

  def show
  end

  def new
    @stakeholder = current_user.account.stakeholders.build
    @stakeholder.stakeholder_type = params[:type] if params[:type].present?
  end

  def create
    @stakeholder = current_user.account.stakeholders.build(stakeholder_params)

    if @stakeholder.save
      redirect_to @stakeholder, notice: "Stakeholder was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @stakeholder.update(stakeholder_params)
      redirect_to @stakeholder, notice: "Stakeholder was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stakeholder.update(status: "archived")
    redirect_to stakeholders_url, notice: "Stakeholder was successfully archived."
  end

  private

  def set_stakeholder
    # @stakeholder = current_user.account.stakeholders.find(params[:id])
    @stakeholder = Stakeholders::Base.find(params[:id])
  end

  def stakeholder_params
    params.require(:stakeholder).permit(
      :name, :email, :phone, :description, :notes,
      :stakeholder_type, :influence_level, :interest_level,
      :priority_score, :status, tags: []
    )
  end

  def filter_stakeholders(stakeholders)
    case params[:filter]
    when "high_influence"
      stakeholders.high_influence
    when "high_interest"
      stakeholders.high_interest
    when "high_priority"
      stakeholders.high_priority
    else
      stakeholders.by_stakeholder_type(params[:filter]) if Stakeholders::Base.stakeholder_types.include?(params[:filter])
    end || stakeholders
  end

  def sort_stakeholders(stakeholders)
    case params[:sort]
    when "name"
      stakeholders.order(:name)
    when "influence"
      stakeholders.order(:influence_level)
    when "interest"
      stakeholders.order(:interest_level)
    when "priority"
      stakeholders.order(priority_score: :desc)
    when "created"
      stakeholders.order(created_at: :desc)
    else
      stakeholders.order(:name)
    end
  end
end
