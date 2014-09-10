class User < ActiveRecord::Base
	has_many :memberships
	has_many :clubs, through: :memberships
	validates :l_name, :uniqueness => { :scope => :f_name, :case_sensitive => false }
	# validates :f_name, uniqueness: true
	# validates :l_name, uniqueness: true
	validates :dob, uniqueness: true
	# validates :club_id, uniqueness: true
end