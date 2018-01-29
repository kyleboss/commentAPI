# frozen_string_literal: true

# A doctor's focus, what most clients will go to her for.
class Specialty < ApplicationRecord
  validates_presence_of :name
end
