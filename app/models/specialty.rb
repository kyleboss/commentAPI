# frozen_string_literal: true

# A doctor's focus, what most clients will go to her for.
class Specialty < ApplicationRecord
  has_many :doctors_specialties
  has_many :doctors, through: :doctors_specialties
  validates_presence_of :name
end
