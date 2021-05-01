defmodule Odoj.Repo do
  use Ecto.Repo,
    otp_app: :odoj,
    adapter: Ecto.Adapters.Postgres
end
