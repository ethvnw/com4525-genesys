# frozen_string_literal: true

# Ensures that the start date is not after the end date and that the start date is not in the past
class DateValidator < ActiveModel::Validator
  def validate(record)
    if record.start_date.present? && record.end_date.present? && record.start_date > record.end_date
      record.errors.add(:start_date, "cannot be after end date")
    end

    if record.start_date.present? && record.start_date < Time.current.change(sec: 0)
      record.errors.add(:start_date, "cannot be in the past")
    end
  end
end
