class Client < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }

  before_create :generate_key
  before_create :generate_secret

  private 

  def generate_key
    # TODO: prevent duplicate key edge case
    self.key = SecureRandom.hex 8
  end

  def generate_secret
    # TODO: prevent duplicate key edge case
    self.secret = SecureRandom.hex 16
  end
  
end
