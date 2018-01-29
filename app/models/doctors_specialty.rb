# frozen_string_literal: true

# Maps a Doctor to a Specialty.
class DoctorsSpecialty < ApplicationRecord
  belongs_to :doctor
  belongs_to :specialty
  validates_presence_of :doctor, :specialty
  validates_associated :doctor, :specialty
end
