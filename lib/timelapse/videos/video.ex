defmodule Timelapse.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Timelapse.Videos.Video

  @primary_key {:id, Timelapse.Video.Permalink, autogenerate: true}

  schema "videos" do
    belongs_to :user, User, foreign_key: :user_id

    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string
    field :camera, :string
    field :frequency, :integer
    field :resolution, :string
    field :status, :integer, default: 0
    field :date_always, :boolean, default: false
    field :from_date, Ecto.DateTime, default: Ecto.DateTime.utc
    field :to_date, Ecto.DateTime, default: Ecto.DateTime.utc
    field :watermark_logo, :string
    field :watermark_position, :integer

    timestamps()
  end

  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description])
    |> validate_required([:url, :title, :description])
    |> slugify_title()
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  def slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  defimpl Phoenix.Param, for: Timelapse.Videos.Video do
    def to_param(%{id: id, slug: slug}) do
      "#{id}-#{slug}"
    end
  end
end
