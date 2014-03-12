class Release < ActiveRecord::Base
  belongs_to :user

  attr_accessible :release_slots

  before_validation :calculate_start_and_end

  validates :start_at, :end_at, presence: true
  validate :release_slots_must_be_consecutive

  def release_slots
    return @release_slots if @release_slots.present?

    if start_at.present? && end_at.present?
      @release_slots ||= ReleaseSlot.between(start_at, end_at)
    else
      []
    end
  end

  def release_slots=(values)
    values.reject!(&:blank?)

    @release_slots = values.map {|s|
      ReleaseSlot.new(start_at: Time.parse(s))
    }
  end

  def save_as(user)
    self.user = user
    save
  end

  private
  def calculate_start_and_end
    sorted = @release_slots.sort_by(&:start_at)

    self.start_at = sorted.first.start_at
    self.end_at = sorted.last.end_at
  end

  def release_slots_must_be_consecutive
    current_slot = @release_slots.first
    (@release_slots - [current_slot]).sort_by(&:start_at).each do |next_slot|
      if next_slot.start_at != current_slot.end_at
        errors.add(:release_slots, "must be consecutive")
      end
      current_slot = next_slot
    end
  end
end
