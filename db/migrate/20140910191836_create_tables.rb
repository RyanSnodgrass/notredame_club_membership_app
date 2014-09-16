class CreateTables < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
        t.string   :name
        t.text     :description
        t.boolean  :accepting
    end
    create_table :memberships do |t|
        t.integer  :club_id
        t.integer  :user_id
    end
    create_table :users do |t|
        t.string   :f_name
        t.string   :l_name
        t.date     :dob
    end
  end

end
