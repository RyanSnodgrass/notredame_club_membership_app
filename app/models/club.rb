class Club < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  # validates :user_id, uniqueness: true

end