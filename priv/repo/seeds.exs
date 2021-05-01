# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Odoj.Repo.insert!(%Odoj.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Odoj.Users

password = "qadr"

users_data = [
  %{name: "Wanti", email: "wanti"},
  %{name: "Husna", email: "husna"},
  %{name: "Sinta", email: "sinta"},
  %{name: "Dwi", email: "dwi"},
  %{name: "Elida", email: "elida"},
  %{name: "Menik", email: "menik"},
  %{name: "Hera", email: "hera"},
  %{name: "Wati", email: "wati"},
  %{name: "Nur Komariyah", email: "nurkomariyah"},
  %{name: "Cahya", email: "cahya"},
  %{name: "Nina Permata", email: "nina"},
  %{name: "Uum", email: "uum"},
  %{name: "Nursa", email: "nursa"}
]

for user <- users_data do
  unless Users.get_member_by_email(user.email) != nil,
         do: Users.register_member(%{email: user.email, name: user.name, password: password})
end