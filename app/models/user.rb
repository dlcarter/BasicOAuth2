class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
end
