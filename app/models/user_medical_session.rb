class UserMedicalSession < ApplicationRecord
  belongs_to :user
  belongs_to :medical_session
end
