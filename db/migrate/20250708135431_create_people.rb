class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_view :people
  end
end
