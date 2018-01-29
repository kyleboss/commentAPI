# frozen_string_literal: true

# An author is a person who writes a comment about a doctor.
class Author < ApplicationRecord
  validates_presence_of :name
end
