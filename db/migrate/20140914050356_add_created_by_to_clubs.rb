class AddCreatedByToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :created_by, :integer
  end
end
