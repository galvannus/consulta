class MedicalSession < ApplicationRecord
  has_many :user_medical_sessions, dependent: :destroy
  has_many :users, through: :user_medical_sessions
  has_many :appointments
end
