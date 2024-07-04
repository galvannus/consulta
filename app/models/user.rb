class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true,
    length: { in: 3..15 },
    format: {
      with: /\A[a-z0-9A-Z]+\z/,
      message: :invalid
    }
  validates :password_digest, presence: true, length: { minimum: 6 }
  validates :email, presence: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: :invalid
    }
  validates :estado, presence: true

  before_save :downcase_attributes

  def user_full_name
    "#{nombre} #{apellido_paterno} #{apellido_materno}"
  end

  private

    def downcase_attributes
      self.username = username.downcase
      self.email = email.downcase
    end

    belongs_to :user_type
    has_many :user_medical_sessions, dependent: :destroy
    has_many :medical_sessions, through: :user_medical_sessions
end
