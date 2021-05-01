defmodule App.Origin do
  @spec check_origin(URI.t()) :: boolean
  def check_origin(%URI{} = origin) do
    origin.authority in ["odoj.gigalixir.com"]
  end
end