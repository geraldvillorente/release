class ReleaseSlot

  attr_reader :start_at
  attr_writer :release

  def initialize(atts={})
    @start_at = atts[:start_at]
  end

  def end_at
    @start_at + 30.minutes
  end

  def release
    return false if @release == false
    @release ||= Release.where('start_at <= ? AND end_at >= ?', start_at, end_at).first
  end

  def available?
    ! release.present?
  end

  def self.for_date(date, include_releases=false)
    # use .to_i here to improve Range#step performance
    slot_times = (first_release(date).to_i..last_release(date).to_i).step(30.minutes).map {|time|
      Time.at(time)
    }

    slots = slot_times.map {|start_at|
      self.new(start_at: start_at)
    }

    # allow releases to be pre-fetched, so n+1 db queries can be avoided when
    # iterating through each slot
    include_releases ? fetch_releases(slots) : slots
  end

  def self.available_for_date(date)
    for_date(date, true).select(&:available?)
  end

  def self.between(start_at, end_at)
    slots = for_date(start_at.to_date)
    slots.select {|s|
      s.start_at >= start_at && s.end_at <= end_at
    }
  end

  def self.first_release(date)
    date.to_time.change(hour: 9, min: 30)
  end

  def self.last_release(date)
    # the last release on a friday is earlier
    if date.cwday == 5
      date.to_time.change(hour: 15, min: 30)
    else
      date.to_time.change(hour: 16, min: 30)
    end
  end

  private

  def self.fetch_releases(slots)
    slots.each do |slot|
      slot.release = false
    end

    releases = Release.where('start_at >= ? AND end_at <= ?', slots.first.start_at, slots.last.end_at)
    releases.each do |release|
      matching_slots = slots.select {|slot|
        slot.start_at >= release.start_at && slot.end_at <= release.end_at
      }

      matching_slots.each do |slot|
        slot.release = release
      end
    end

    slots
  end

end
