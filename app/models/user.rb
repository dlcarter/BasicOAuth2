class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }
  belongs_to :client
end
