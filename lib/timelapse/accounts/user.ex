defmodule Timelapse.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Timelapse.Accounts.User

  @moduledoc false

  @email_regex ~r/^(?!.*\.{2})[a-z0-9.-]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/
  @name_regex ~r/^[\p{Xwd}\s,.']+$/

  @required_fields ~w(password firstname lastname email)
  @optional_fields ~w(username telegram_username referral_url api_id api_key reset_token token_expires_at payment_method country_id confirmed_at updated_at last_login_at created_at)

  schema "users" do
    belongs_to :country, Country, foreign_key: :country_id
    has_many :cameras, Camera, foreign_key: :owner_id
    has_many :camera_shares, CameraShare
    has_one :access_tokens, AccessToken
    has_many :videos, Timelapse.Videos.Video

    field :username, :string
    field :telegram_username, :string
    field :referral_url, :string
    field :password, :string
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :api_id, :string
    field :api_key, :string
    field :reset_token, :string
    field :token_expires_at, Ecto.DateTime
    field :stripe_customer_id, :string
    field :confirmed_at, Ecto.DateTime
    field :last_login_at, Ecto.DateTime
    field :payment_method, :integer
    timestamps(inserted_at: :created_at, type: Ecto.DateTime, default: Ecto.DateTime.utc)
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, hash_password(password))
      _ ->
        changeset
    end
  end

  def hash_password(password) do
    Comeonin.Bcrypt.hashpass(password, Comeonin.Bcrypt.gen_salt(12, true))
  end

  def has_username(changeset) do
    case get_field(changeset, :username) do
      username when username in [nil, ""] -> put_change(changeset, :username, get_field(changeset, :email))
      _ ->
        changeset
        |> put_change(:username, get_field(changeset, :email))
        |> update_change(:username, &String.downcase/1)
    end
  end

  def required_fields do
    @required_fields |> Enum.map(fn(field) -> String.to_atom(field) end)
  end

  def registration_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(required_fields())
    |> has_username
    |> unique_constraint(:email, [name: :user_email_unique_index, message: "Email has already been taken."])
    |> unique_constraint(:username, [name: :user_username_unique_index, message: "Username has already been taken."])
    |> validate_format(:firstname, @name_regex)
    |> validate_format(:lastname, @name_regex)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, @email_regex, [message: "Email format isn't valid!"])
    |> validate_length(:password, [min: 6, message: "Password should be at least 6 character(s)."])
    |> encrypt_password
    |> update_change(:firstname, &String.trim/1)
    |> update_change(:lastname, &String.trim/1)
    |> validate_length(:firstname, [min: 2, message: "Firstname should be at least 2 character(s)."])
    |> validate_length(:lastname, [min: 2, message: "Lastname should be at least 2 character(s)."])
  end
end
