defmodule Odoj.UsersTest do
  use Odoj.DataCase

  alias Odoj.Users
  import Odoj.UsersFixtures
  alias Odoj.Users.{Member, MemberToken}

  describe "get_member_by_email/1" do
    test "does not return the member if the email does not exist" do
      refute Users.get_member_by_email("unknown@example.com")
    end

    test "returns the member if the email exists" do
      %{id: id} = member = member_fixture()
      assert %Member{id: ^id} = Users.get_member_by_email(member.email)
    end
  end

  describe "get_member_by_email_and_password/2" do
    test "does not return the member if the email does not exist" do
      refute Users.get_member_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the member if the password is not valid" do
      member = member_fixture()
      refute Users.get_member_by_email_and_password(member.email, "invalid")
    end

    test "returns the member if the email and password are valid" do
      %{id: id} = member = member_fixture()

      assert %Member{id: ^id} =
               Users.get_member_by_email_and_password(member.email, valid_member_password())
    end
  end

  describe "get_member!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Users.get_member!(-1)
      end
    end

    test "returns the member with the given id" do
      %{id: id} = member = member_fixture()
      assert %Member{id: ^id} = Users.get_member!(member.id)
    end
  end

  describe "register_member/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Users.register_member(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} = Users.register_member(%{email: "not valid", password: "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 12 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Users.register_member(%{email: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = member_fixture()
      {:error, changeset} = Users.register_member(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Users.register_member(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers members with a hashed password" do
      email = unique_member_email()
      {:ok, member} = Users.register_member(valid_member_attributes(email: email))
      assert member.email == email
      assert is_binary(member.hashed_password)
      assert is_nil(member.confirmed_at)
      assert is_nil(member.password)
    end
  end

  describe "change_member_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Users.change_member_registration(%Member{})
      assert changeset.required == [:password, :email]
    end

    test "allows fields to be set" do
      email = unique_member_email()
      password = valid_member_password()

      changeset =
        Users.change_member_registration(
          %Member{},
          valid_member_attributes(email: email, password: password)
        )

      assert changeset.valid?
      assert get_change(changeset, :email) == email
      assert get_change(changeset, :password) == password
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "change_member_email/2" do
    test "returns a member changeset" do
      assert %Ecto.Changeset{} = changeset = Users.change_member_email(%Member{})
      assert changeset.required == [:email]
    end
  end

  describe "apply_member_email/3" do
    setup do
      %{member: member_fixture()}
    end

    test "requires email to change", %{member: member} do
      {:error, changeset} = Users.apply_member_email(member, valid_member_password(), %{})
      assert %{email: ["did not change"]} = errors_on(changeset)
    end

    test "validates email", %{member: member} do
      {:error, changeset} =
        Users.apply_member_email(member, valid_member_password(), %{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{member: member} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Users.apply_member_email(member, valid_member_password(), %{email: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{member: member} do
      %{email: email} = member_fixture()

      {:error, changeset} =
        Users.apply_member_email(member, valid_member_password(), %{email: email})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates current password", %{member: member} do
      {:error, changeset} =
        Users.apply_member_email(member, "invalid", %{email: unique_member_email()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the email without persisting it", %{member: member} do
      email = unique_member_email()
      {:ok, member} = Users.apply_member_email(member, valid_member_password(), %{email: email})
      assert member.email == email
      assert Users.get_member!(member.id).email != email
    end
  end

  describe "deliver_update_email_instructions/3" do
    setup do
      %{member: member_fixture()}
    end

    test "sends token through notification", %{member: member} do
      token =
        extract_member_token(fn url ->
          Users.deliver_update_email_instructions(member, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert member_token = Repo.get_by(MemberToken, token: :crypto.hash(:sha256, token))
      assert member_token.member_id == member.id
      assert member_token.sent_to == member.email
      assert member_token.context == "change:current@example.com"
    end
  end

  describe "update_member_email/2" do
    setup do
      member = member_fixture()
      email = unique_member_email()

      token =
        extract_member_token(fn url ->
          Users.deliver_update_email_instructions(%{member | email: email}, member.email, url)
        end)

      %{member: member, token: token, email: email}
    end

    test "updates the email with a valid token", %{member: member, token: token, email: email} do
      assert Users.update_member_email(member, token) == :ok
      changed_member = Repo.get!(Member, member.id)
      assert changed_member.email != member.email
      assert changed_member.email == email
      assert changed_member.confirmed_at
      assert changed_member.confirmed_at != member.confirmed_at
      refute Repo.get_by(MemberToken, member_id: member.id)
    end

    test "does not update email with invalid token", %{member: member} do
      assert Users.update_member_email(member, "oops") == :error
      assert Repo.get!(Member, member.id).email == member.email
      assert Repo.get_by(MemberToken, member_id: member.id)
    end

    test "does not update email if member email changed", %{member: member, token: token} do
      assert Users.update_member_email(%{member | email: "current@example.com"}, token) == :error
      assert Repo.get!(Member, member.id).email == member.email
      assert Repo.get_by(MemberToken, member_id: member.id)
    end

    test "does not update email if token expired", %{member: member, token: token} do
      {1, nil} = Repo.update_all(MemberToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Users.update_member_email(member, token) == :error
      assert Repo.get!(Member, member.id).email == member.email
      assert Repo.get_by(MemberToken, member_id: member.id)
    end
  end

  describe "change_member_password/2" do
    test "returns a member changeset" do
      assert %Ecto.Changeset{} = changeset = Users.change_member_password(%Member{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Users.change_member_password(%Member{}, %{
          "password" => "new valid password"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_member_password/3" do
    setup do
      %{member: member_fixture()}
    end

    test "validates password", %{member: member} do
      {:error, changeset} =
        Users.update_member_password(member, valid_member_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{member: member} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Users.update_member_password(member, valid_member_password(), %{password: too_long})

      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{member: member} do
      {:error, changeset} =
        Users.update_member_password(member, "invalid", %{password: valid_member_password()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{member: member} do
      {:ok, member} =
        Users.update_member_password(member, valid_member_password(), %{
          password: "new valid password"
        })

      assert is_nil(member.password)
      assert Users.get_member_by_email_and_password(member.email, "new valid password")
    end

    test "deletes all tokens for the given member", %{member: member} do
      _ = Users.generate_member_session_token(member)

      {:ok, _} =
        Users.update_member_password(member, valid_member_password(), %{
          password: "new valid password"
        })

      refute Repo.get_by(MemberToken, member_id: member.id)
    end
  end

  describe "generate_member_session_token/1" do
    setup do
      %{member: member_fixture()}
    end

    test "generates a token", %{member: member} do
      token = Users.generate_member_session_token(member)
      assert member_token = Repo.get_by(MemberToken, token: token)
      assert member_token.context == "session"

      # Creating the same token for another member should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%MemberToken{
          token: member_token.token,
          member_id: member_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_member_by_session_token/1" do
    setup do
      member = member_fixture()
      token = Users.generate_member_session_token(member)
      %{member: member, token: token}
    end

    test "returns member by token", %{member: member, token: token} do
      assert session_member = Users.get_member_by_session_token(token)
      assert session_member.id == member.id
    end

    test "does not return member for invalid token" do
      refute Users.get_member_by_session_token("oops")
    end

    test "does not return member for expired token", %{token: token} do
      {1, nil} = Repo.update_all(MemberToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Users.get_member_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      member = member_fixture()
      token = Users.generate_member_session_token(member)
      assert Users.delete_session_token(token) == :ok
      refute Users.get_member_by_session_token(token)
    end
  end

  describe "deliver_member_confirmation_instructions/2" do
    setup do
      %{member: member_fixture()}
    end

    test "sends token through notification", %{member: member} do
      token =
        extract_member_token(fn url ->
          Users.deliver_member_confirmation_instructions(member, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert member_token = Repo.get_by(MemberToken, token: :crypto.hash(:sha256, token))
      assert member_token.member_id == member.id
      assert member_token.sent_to == member.email
      assert member_token.context == "confirm"
    end
  end

  describe "confirm_member/1" do
    setup do
      member = member_fixture()

      token =
        extract_member_token(fn url ->
          Users.deliver_member_confirmation_instructions(member, url)
        end)

      %{member: member, token: token}
    end

    test "confirms the email with a valid token", %{member: member, token: token} do
      assert {:ok, confirmed_member} = Users.confirm_member(token)
      assert confirmed_member.confirmed_at
      assert confirmed_member.confirmed_at != member.confirmed_at
      assert Repo.get!(Member, member.id).confirmed_at
      refute Repo.get_by(MemberToken, member_id: member.id)
    end

    test "does not confirm with invalid token", %{member: member} do
      assert Users.confirm_member("oops") == :error
      refute Repo.get!(Member, member.id).confirmed_at
      assert Repo.get_by(MemberToken, member_id: member.id)
    end

    test "does not confirm email if token expired", %{member: member, token: token} do
      {1, nil} = Repo.update_all(MemberToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Users.confirm_member(token) == :error
      refute Repo.get!(Member, member.id).confirmed_at
      assert Repo.get_by(MemberToken, member_id: member.id)
    end
  end

  describe "deliver_member_reset_password_instructions/2" do
    setup do
      %{member: member_fixture()}
    end

    test "sends token through notification", %{member: member} do
      token =
        extract_member_token(fn url ->
          Users.deliver_member_reset_password_instructions(member, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert member_token = Repo.get_by(MemberToken, token: :crypto.hash(:sha256, token))
      assert member_token.member_id == member.id
      assert member_token.sent_to == member.email
      assert member_token.context == "reset_password"
    end
  end

  describe "get_member_by_reset_password_token/1" do
    setup do
      member = member_fixture()

      token =
        extract_member_token(fn url ->
          Users.deliver_member_reset_password_instructions(member, url)
        end)

      %{member: member, token: token}
    end

    test "returns the member with valid token", %{member: %{id: id}, token: token} do
      assert %Member{id: ^id} = Users.get_member_by_reset_password_token(token)
      assert Repo.get_by(MemberToken, member_id: id)
    end

    test "does not return the member with invalid token", %{member: member} do
      refute Users.get_member_by_reset_password_token("oops")
      assert Repo.get_by(MemberToken, member_id: member.id)
    end

    test "does not return the member if token expired", %{member: member, token: token} do
      {1, nil} = Repo.update_all(MemberToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Users.get_member_by_reset_password_token(token)
      assert Repo.get_by(MemberToken, member_id: member.id)
    end
  end

  describe "reset_member_password/2" do
    setup do
      %{member: member_fixture()}
    end

    test "validates password", %{member: member} do
      {:error, changeset} =
        Users.reset_member_password(member, %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{member: member} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Users.reset_member_password(member, %{password: too_long})
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{member: member} do
      {:ok, updated_member} = Users.reset_member_password(member, %{password: "new valid password"})
      assert is_nil(updated_member.password)
      assert Users.get_member_by_email_and_password(member.email, "new valid password")
    end

    test "deletes all tokens for the given member", %{member: member} do
      _ = Users.generate_member_session_token(member)
      {:ok, _} = Users.reset_member_password(member, %{password: "new valid password"})
      refute Repo.get_by(MemberToken, member_id: member.id)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%Member{password: "123456"}) =~ "password: \"123456\""
    end
  end

  describe "logs" do
    alias Odoj.Users.Log

    @valid_attrs %{date: ~N[2010-04-17 14:00:00], juz: 42, surah: "some surah", verse: 42}
    @update_attrs %{date: ~N[2011-05-18 15:01:01], juz: 43, surah: "some updated surah", verse: 43}
    @invalid_attrs %{date: nil, juz: nil, surah: nil, verse: nil}

    def log_fixture(attrs \\ %{}) do
      {:ok, log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_log()

      log
    end

    test "list_logs/0 returns all logs" do
      log = log_fixture()
      assert Users.list_logs() == [log]
    end

    test "get_log!/1 returns the log with given id" do
      log = log_fixture()
      assert Users.get_log!(log.id) == log
    end

    test "create_log/1 with valid data creates a log" do
      assert {:ok, %Log{} = log} = Users.create_log(@valid_attrs)
      assert log.date == ~N[2010-04-17 14:00:00]
      assert log.juz == 42
      assert log.surah == "some surah"
      assert log.verse == 42
    end

    test "create_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_log(@invalid_attrs)
    end

    test "update_log/2 with valid data updates the log" do
      log = log_fixture()
      assert {:ok, %Log{} = log} = Users.update_log(log, @update_attrs)
      assert log.date == ~N[2011-05-18 15:01:01]
      assert log.juz == 43
      assert log.surah == "some updated surah"
      assert log.verse == 43
    end

    test "update_log/2 with invalid data returns error changeset" do
      log = log_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_log(log, @invalid_attrs)
      assert log == Users.get_log!(log.id)
    end

    test "delete_log/1 deletes the log" do
      log = log_fixture()
      assert {:ok, %Log{}} = Users.delete_log(log)
      assert_raise Ecto.NoResultsError, fn -> Users.get_log!(log.id) end
    end

    test "change_log/1 returns a log changeset" do
      log = log_fixture()
      assert %Ecto.Changeset{} = Users.change_log(log)
    end
  end
end
