class Permission < ApplicationRecord
    validates :nombre, presence: true
    validates :descripcion, presence: true

    has_many :user_type_permissions, dependent: :destroy
    has_many :user_types, through: :user_type_permissions
end
