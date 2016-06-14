class Session < ActiveRecord::Base

  def refresh!
    # TODO: handle duplicate key edge case
    self.update_attributes(
      token: SecureRandom.hex(16),
      refresh_token: SecureRandom.hex(16),
      expires_at: Time.now + 1.hour
    )
  end
end
