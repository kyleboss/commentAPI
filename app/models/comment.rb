# frozen_string_literal: true

# A comment links a doctor with a patient along with a rating and text describing the experience.
class Comment < ApplicationRecord
  belongs_to :doctor
  belongs_to :author
  validates_presence_of :doctor, :author, :body, :rating
  validates_numericality_of :rating
  validates_associated :doctor, :author

  scope :recent_average_rating_for, (lambda do |doctor|
    where(doctor: doctor).limit(100).order(created_at: :desc).average(:rating)
  end)
end
