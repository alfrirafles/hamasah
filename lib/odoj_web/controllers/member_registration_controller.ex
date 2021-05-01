defmodule OdojWeb.MemberRegistrationController do
  use OdojWeb, :controller

  alias Odoj.Users
  alias Odoj.Users.Member
  alias OdojWeb.MemberAuth

  def new(conn, _params) do
    changeset = Users.change_member_registration(%Member{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"member" => member_params}) do
    case Users.register_member(member_params) do
      {:ok, member} ->
        {:ok, _} =
          Users.deliver_member_confirmation_instructions(
            member,
            &Routes.member_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "Member created successfully.")
        |> MemberAuth.log_in_member(member)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
