defmodule Odoj.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :member_id, references("members"), null: false
      add :date, :naive_datetime
      add :juz, :integer
      add :surah, :string
      add :verse, :integer

      timestamps()
    end

  end
end
