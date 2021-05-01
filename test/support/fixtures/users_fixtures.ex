defmodule Odoj.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Odoj.Users` context.
  """

  def unique_member_email, do: "member#{System.unique_integer()}@example.com"
  def valid_member_password, do: "hello world!"

  def valid_member_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_member_email(),
      password: valid_member_password()
    })
  end

  def member_fixture(attrs \\ %{}) do
    {:ok, member} =
      attrs
      |> valid_member_attributes()
      |> Odoj.Users.register_member()

    member
  end

  def extract_member_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
