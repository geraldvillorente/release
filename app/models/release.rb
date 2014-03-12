class Release < ActiveRecord::Base
  belongs_to :user

  attr_accessible :release_slots

  def release_slots
    unless start_at.present? && end_at.present?
      return []
    end

    ReleaseSlot.between(start_at, end_at)
  end

  def release_slots=(values)
    values.reject!(&:blank?)

    slots = values.map {|s|
      ReleaseSlot.new(start_at: Time.parse(s))
    }.sort_by(&:start_at)

    self.start_at = slots.first.start_at
    self.end_at = slots.last.end_at
  end

  def save_as(user)
    self.user = user
    save
  end
end
