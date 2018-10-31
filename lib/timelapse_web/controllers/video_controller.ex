defmodule TimelapseWeb.VideoController do
  use TimelapseWeb, :controller

  alias Timelapse.Videos
  alias Timelapse.Videos.Video

  import Timelapse.Auth, only: [load_current_user: 2]
  @region Application.get_env(:ex_aws, :region)

  plug(:load_current_user)
  plug(:authorize_video when action in [:edit, :update, :delete])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _user) do
    videos = Videos.list_videos()
    render(conn, "index.html", videos: videos)
  end

  @doc """
  def get_presigned_url_to_object(path) do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(:get, "timelapse-server", path)
  end

  def play(conn, %{"id" => exid, "archive_id" => archive_id}) do
    current_user = conn.assigns[:current_user]
    camera = Camera.get_full(exid)

    with :ok <- ensure_can_list(current_user, camera, conn) do
      {:ok, url} = get_presigned_url_to_object('camera_id.mp4')
      conn
      |> redirect(external: url)
    end
  end

  def load(camera_exid, timestamp) do
    file_path = convert_timestamp_to_path(timestamp)
    'camera_exid/snapshots/file_path'
    |> do_load
  end

  def do_load(path) do
    case ExAws.S3.get_object("evercam-camera-assets", path) |> ExAws.request do
      {:ok, response} -> {:ok, response.body}
      {:error, {:http_error, code, response}} ->
        message = EvercamMedia.XMLParser.parse_single(response.body, '/Error/Message')
        {:error, code, message}
    end
  end
  """

  def new(conn, _params, user) do
    changeset = Videos.change_video(%Video{}, %{}, user)
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    render(conn, "show.html", video: video)
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
