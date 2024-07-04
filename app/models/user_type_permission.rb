class UserTypePermission < ApplicationRecord
  validates :permission_id, presence: true
  validates :user_type_id, presence: true

  belongs_to :permission
  belongs_to :user_type
end
