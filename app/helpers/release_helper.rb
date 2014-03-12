# encoding: UTF-8
module ReleaseHelper

  def release_slots_for_select(form)
    slots = ReleaseSlot.for_date(release_slot_date(form), true)
    pairs = slots.map {|s|
      [label_for_slot(s), s.start_at]
    }

    selected = []
    disabled = slots.reject(&:available?).map(&:start_at)

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

  private
  def label_for_slot(slot)
    "#{slot.start_at.strftime('%H:%M')} → #{slot.end_at.strftime('%H:%M')}"
  end

end
