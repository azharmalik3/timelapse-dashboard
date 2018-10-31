defmodule Timelapse.Videos do
  @moduledoc """
  The Videos context.
  """

  import Ecto.Query, warn: false
  alias Timelapse.Repo

  alias Timelapse.Videos.Video

  def list_videos do
    Video
    |> Repo.all()
  end

  def get_video!(id) do
    Video
    |> Repo.get!(id)
  end

  def uploaded_video(attrs \\ %{}, user) do
    changeset = change_video(%Video{}, attrs, user)

    changeset
    |> Repo.insert()
  end

  def create_video(attrs \\ %{}, user) do
    changeset = change_video(%Video{}, attrs, user)

    changeset
    |> Repo.insert()
  end

  def update_video(%Video{} = video, attrs, _user) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  def change_video(%Video{} = _video, params, user) do
    user
    |> Ecto.build_assoc(:videos)
    |> Video.changeset(params)
  end
end
