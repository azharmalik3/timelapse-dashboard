defmodule TimelapseWeb.VideoController do
  use TimelapseWeb, :controller

  alias Timelapse.Videos
  alias Timelapse.Videos.Video

  import Timelapse.Auth, only: [load_current_user: 2]

  plug(:load_current_user)
  plug(:authorize_video when action in [:edit, :update, :delete])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def get_videos(conn, _params, _user) do
    logs =
      Videos.list_videos()
      |> Enum.map(fn(videos) ->
        id = videos.id
        url = videos.url
        title = videos.title

        %{
          "id" => id,
          "url" => url,
          "title" => title
        }
      end)
    conn
    |> put_status(:created)
    |> json(%{
        "logs": logs
      })
  end

  def edit(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    changeset = Ecto.Changeset.change(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Videos.get_video!(id)

    case Videos.update_video(video, video_params, user) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    {:ok, _video} = Videos.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  defp authorize_video(conn, _) do
    video = Timelapse.Videos.get_video!(conn.params["id"])

    if conn.assigns.current_user.id == video.user_id do
      assign(conn, :video, video)
    else
      conn
      |> put_flash(:error, "You don't have authorization for this operation!")
      |> redirect(to: video_path(conn, :index))
      |> halt()
    end
  end
end
