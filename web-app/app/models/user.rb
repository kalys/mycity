class User < ApplicationRecord
	include TheRole::Api::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
  validates :name, presence: true, length: { minimum: 2 }
end
