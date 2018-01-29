# frozen_string_literal: true

# A bunch of related doctors.
class Group < ApplicationRecord
  has_many :doctors
end
