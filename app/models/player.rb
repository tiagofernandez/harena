class Player < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable :lockable :timeoutable :omniauthable :recoverable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  validates :username,
            presence: true,
            length: { in: 3..20 },
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9\_]+\z/i, message: "should only contain letters, numbers, and underscores" }

  validates :timezone,
            presence: true,
            length: { in: 13..40 },
            format: { with: /\AGMT[+-][01]\d:[0-5][05]\s.{3,}\z/, message: "should be formatted as 'GMT+00:00 Region'" }

  has_many :registrations
  has_many :tournaments, through: :registrations

  def remember_me
    true
  end
end
