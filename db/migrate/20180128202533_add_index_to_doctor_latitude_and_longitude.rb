# frozen_string_literal: true

class AddIndexToDoctorLatitudeAndLongitude < ActiveRecord::Migration[5.2]
  def self.up
    add_index :doctors, %i[latitude longitude]
  end

  def self.down
    remove_index :doctors, %i[latitude longitude]
  end
end
