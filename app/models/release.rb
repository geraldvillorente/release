class Release < ActiveRecord::Base
  belongs_to :user

  def save_as(user)
    self.user = user
    save
  end
end
