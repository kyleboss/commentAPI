# frozen_string_literal: true

# A Doctor represents a doctor listing. A doctor can be commented about, be put in a group, and have several
# specialties.
class Doctor < ApplicationRecord
  belongs_to :group
  has_many :doctors_specialties
  has_many :specialties, through: :doctors_specialties
  has_many :comments
  acts_as_mappable lat_column_name: :latitude, lng_column_name: :longitude
  validates_presence_of :group, :name, :street_address, :longitude, :latitude, :city, :state, :zip_code
  validates_associated :group
  validates_numericality_of :longitude, :latitude

  # The "overall" rating of the doctor. By overall, we are using only the last 100 ratings. This design decision was
  # made because trends tend to be more important than long-term scores. Cached because it could be a heavy call
  # and is treated like an attribute.
  def recent_average_rating
    @_recent_average_rating ||= comments.empty? ? 0 : Comment.recent_average_rating_for(self)
  end
end
