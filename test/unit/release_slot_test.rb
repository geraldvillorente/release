require "test_helper"
require "release_slot"

class ReleaseSlotTest < ActiveSupport::TestCase

  def start_at
    Time.now.beginning_of_hour
  end

  should "have a start and end time and be available by default" do
    slot = ReleaseSlot.new(start_at: start_at)

    assert_equal start_at, slot.start_at
    assert_equal start_at+30.minutes, slot.end_at

    assert slot.available?
  end

  should "allow a release to be specified" do
    release = build(:release)

    slot = ReleaseSlot.new(start_at: start_at)
    slot.release = release

    Release.expects(:where).never
    assert_equal release, slot.release
  end

  should "allow a release to be marked as not present" do
    slot = ReleaseSlot.new(start_at: start_at)
    slot.release = false

    Release.expects(:where).never
    assert_equal false, slot.release
  end

  should "find a release for the slot" do
    release = create(:release, start_at: start_at, end_at: start_at+30.minutes)
    release_slot = ReleaseSlot.new(start_at: start_at)

    assert_equal release, release_slot.release
    assert_equal false, release_slot.available?
  end

  should "find a release that spans multiple slots" do
    release = create(:release, start_at: start_at, end_at: start_at+60.minutes)

    # initialize a release slot for the last 30 minutes
    release_slot = ReleaseSlot.new(start_at: start_at+30.minutes)

    assert_equal release, release_slot.release
    assert_equal false, release_slot.available?
  end

  should "return release slots in 30 minute intervals for a day" do
    date = Date.today

    release_slots = ReleaseSlot.for_date(date)

    assert_equal 15, release_slots.size
    assert_equal "09:30", release_slots.first.start_at.strftime("%H:%M")
    assert_equal "16:30", release_slots.last.start_at.strftime("%H:%M")
  end

  should "return all available release slots for a day" do
    start_of_day = Time.now.change(hour: 9, min: 30)

    create(:release, start_at: start_of_day, end_at: start_of_day+4.hours)
    create(:release, start_at: start_of_day+5.hours, end_at: start_of_day+6.hours)

    release_slots = ReleaseSlot.available_for_date(Date.today)
    available_times = release_slots.map {|s| s.start_at.strftime("%H:%M") }

    assert_equal ["13:30", "14:00", "15:30", "16:00", "16:30"], available_times
  end

end
