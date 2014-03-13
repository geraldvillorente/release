# encoding: UTF-8
module ReleaseHelper

  def release_slots_for_select(form)
    slots = ReleaseSlot.for_date(release_slot_date(form), true)
    pairs = slots.map {|s|
      [label_for_slot(s), s.start_at]
    }
    disabled = slots.reject(&:available?).map(&:start_at)

    selected = []
    if (existing_slots = form.object.release_slots)
      selected = existing_slots.map(&:start_at)
      disabled = disabled - selected
    end

    options_for_select(pairs, disabled: disabled, selected: selected)
  end

  def release_slot_date(form)
    date = case
           when form.object.persisted? then form.object.start_at.to_date
           when params[:date].present? then Date.parse(params[:date])
           else
             Date.today
           end
  end

  def next_day(form)
    next_day = (release_slot_date(form) + 1.day)
    next_day.cwday > 5 ? next_day.next_week(:monday) : next_day
  end

  def prev_day(form)
    current_day = release_slot_date(form)
    current_day.cwday == 1 ? current_day.prev_week(:friday) : (current_day - 1.day)
  end

  def url_to_next_day(form)
    new_release_path(:date => next_day(form))
  end

  def url_to_prev_day(form)
    new_release_path(:date => prev_day(form))
  end

  private
  def label_for_slot(slot)
    "#{slot.start_at.strftime('%H:%M')} → #{slot.end_at.strftime('%H:%M')}"
  end

end
