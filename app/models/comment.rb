class Comment < ApplicationRecord
  belongs_to :doctor
  belongs_to :author
end
