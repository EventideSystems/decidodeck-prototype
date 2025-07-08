# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :authenticate_user!

  def index
    @people = Person.all
  end
end
