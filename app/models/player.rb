class Player < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  validates :username,
            presence: true,
            length: { in: 3..20 },
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9]+\z/i, message: "should only contain letters and numbers" }

  validates :timezone,
            presence: true,
            length: { in: 13..40 },
            format: { with: /\AGMT[+-][01]\d:[0-5][05]\s.{3,}\z/, message: "should be formatted as 'GMT+00:00 Region'" }

  has_many :registrations
  has_many :tournaments, through: :registrations

end
