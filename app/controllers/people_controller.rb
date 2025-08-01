# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_account

  def index
    @people = policy_scope(Person).all
  end

  private

  def ensure_current_account
    redirect_to new_user_session_path unless current_account
  end
end
