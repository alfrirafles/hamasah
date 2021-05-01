defmodule OdojWeb.MemberConfirmationControllerTest do
  use OdojWeb.ConnCase, async: true

  alias Odoj.Users
  alias Odoj.Repo
  import Odoj.UsersFixtures

  setup do
    %{member: member_fixture()}
  end

  describe "GET /members/confirm" do
    test "renders the confirmation page", %{conn: conn} do
      conn = get(conn, Routes.member_confirmation_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Resend confirmation instructions</h1>"
    end
  end

  describe "POST /members/confirm" do
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, member: member} do
      conn =
        post(conn, Routes.member_confirmation_path(conn, :create), %{
          "member" => %{"email" => member.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(Users.MemberToken, member_id: member.id).context == "confirm"
    end

    test "does not send confirmation token if Member is confirmed", %{conn: conn, member: member} do
      Repo.update!(Users.Member.confirm_changeset(member))

      conn =
        post(conn, Routes.member_confirmation_path(conn, :create), %{
          "member" => %{"email" => member.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      refute Repo.get_by(Users.MemberToken, member_id: member.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.member_confirmation_path(conn, :create), %{
          "member" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(Users.MemberToken) == []
    end
  end

  describe "GET /members/confirm/:token" do
    test "confirms the given token once", %{conn: conn, member: member} do
      token =
        extract_member_token(fn url ->
          Users.deliver_member_confirmation_instructions(member, url)
        end)

      conn = get(conn, Routes.member_confirmation_path(conn, :confirm, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "Member confirmed successfully"
      assert Users.get_member!(member.id).confirmed_at
      refute get_session(conn, :member_token)
      assert Repo.all(Users.MemberToken) == []

      # When not logged in
      conn = get(conn, Routes.member_confirmation_path(conn, :confirm, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Member confirmation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_member(member)
        |> get(Routes.member_confirmation_path(conn, :confirm, token))

      assert redirected_to(conn) == "/"
      refute get_flash(conn, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, member: member} do
      conn = get(conn, Routes.member_confirmation_path(conn, :confirm, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Member confirmation link is invalid or it has expired"
      refute Users.get_member!(member.id).confirmed_at
    end
  end
end
