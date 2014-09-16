class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :memberships
  has_many :clubs, through: :memberships
  validates :l_name, :uniqueness => { :scope => [:f_name, :dob], :case_sensitive => false }

  # validates :dob, uniqueness: true
end