class UserType < ApplicationRecord
    validates :nombre, presence: true
    validates :descripcion, presence: true
    
    has_many :user_type_permissions, dependent: :destroy
    has_many :permissions, through: :user_type_permissions
    has_many :users
end
