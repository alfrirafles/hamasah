defmodule Odoj.Timer do
  def current_datetime do
    NaiveDateTime.utc_now
    |> NaiveDateTime.add(7 * 3600, :second)
    |> NaiveDateTime.truncate(:second)
  end

  def current_day do
    current_datetime().day
  end

  def current_date do
    current_datetime() |> NaiveDateTime.to_date
  end
end