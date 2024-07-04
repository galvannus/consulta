class Service < ApplicationRecord
  belongs_to :category
  has_many :service_acquireds, dependent: :destroy
  has_many :appointments, through: :service_acquireds
end
