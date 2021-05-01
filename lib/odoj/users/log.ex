defmodule Odoj.Users.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :date, :naive_datetime
    field :juz, :integer
    field :surah, :string
    field :verse, :integer

    belongs_to :member, Odoj.Users.Member

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:date, :juz, :member_id, :surah, :verse])
    |> validate_required([:date, :juz, :member_id])
  end
end
