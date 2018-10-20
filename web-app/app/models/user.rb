# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true, length: { minimum: 2 }

  # TODO: by @kalys
  # remove later
  def admin?
    true
  end
end
