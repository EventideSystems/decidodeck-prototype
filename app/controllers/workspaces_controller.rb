# frozen_string_literal: true

class WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_account
  before_action :set_workspace, only: [ :show, :edit, :update, :destroy ]

  def index
    @workspaces = Workspace.all
    # @workspaces = current_account.workspaces# .active
    # debugger
  end

  def show
  end

  def new
    @workspace = current_account.workspaces.build
  end

  def create
    @workspace = current_account.workspaces.build(workspace_params)

    if @workspace.save
      redirect_to @workspace, notice: "Workspace was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @workspace.update(workspace_params)
      redirect_to @workspace, notice: "Workspace was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workspace.discard
    redirect_to workspaces_path, notice: "Workspace was successfully archived."
  end

  private

  def set_workspace
    @workspace = current_account.workspaces.find(params[:id])
  end

  def workspace_params
    params.require(:workspace).permit(:name, :description, :workspace_type, :status)
  end

  def ensure_current_account
    redirect_to new_user_session_path unless current_account
  end
end
