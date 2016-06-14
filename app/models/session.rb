class Session < ActiveRecord::Base

  def generate_token!
    # TODO: handle duplicate key edge case
    self.update_attribute(:token, SecureRandom.hex(16))
  end
end
