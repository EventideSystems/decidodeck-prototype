# frozen_string_literal: true

class StakeholdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stakeholder, only: [ :show, :edit, :update, :destroy ]

  def index
    @stakeholders = current_account.stakeholders.active.includes(:account)

    # @stakeholders = Stakeholders::Base.

    @stakeholders = filter_stakeholders(@stakeholders) if params[:filter].present?
    @stakeholders = sort_stakeholders(@stakeholders) if params[:sort].present?
  end

  def show
  end

  def new
    stakeholder_type = params[:type] || "Stakeholders::Individual"

    # Build the appropriate stakeholder subclass
    @stakeholder = case stakeholder_type
                   when "Stakeholders::Individual", "individual"
                     current_account.stakeholders.build(type: "Stakeholders::Individual")
                   when "Stakeholders::Organization", "organization"
                     current_account.stakeholders.build(type: "Stakeholders::Organization")
                   else
                     current_account.stakeholders.build(type: "Stakeholders::Individual")
                   end

    @stakeholder.stakeholder_type = params[:stakeholder_type] if params[:stakeholder_type].present?
  end

  def create
    stakeholder_type = stakeholder_params[:type] || "Stakeholders::Individual"

    # Build the appropriate stakeholder subclass
    @stakeholder = case stakeholder_type
                   when "Stakeholders::Individual", "individual"
                     current_account.stakeholders.build(stakeholder_params.merge(type: "Stakeholders::Individual"))
                   when "Stakeholders::Organization", "organization"
                     current_account.stakeholders.build(stakeholder_params.merge(type: "Stakeholders::Organization"))
                   else
                     current_account.stakeholders.build(stakeholder_params.merge(type: "Stakeholders::Individual"))
                   end

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
      redirect_to stakeholder_url(@stakeholder), notice: "Stakeholder was successfully updated."
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
    class_key = (@stakeholder&.class&.name || "Stakeholders::Base").underscore.tr("/", "_")

    params.require(class_key).permit(
      :name, :first_name, :last_name, :job_title, :email, :phone, :description, :notes,
      :stakeholder_type, :influence_level, :interest_level, :type,
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
