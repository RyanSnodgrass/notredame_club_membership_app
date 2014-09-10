class User < ActiveRecord::Base
	has_many :memberships
	has_many :clubs, through: :memberships
end