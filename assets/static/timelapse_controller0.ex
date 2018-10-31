defmodule TimelapseWeb.TimelapseController do

  use TimelapseWeb, :controller
  require Logger
  import Timelapse.Auth, only: [load_current_user: 2]
  alias Timelapse.Videos
  alias Timelapse.Videos.Video

  plug(:load_current_user)

  def index(conn, _params) do
    render conn, "index.html"
  end

  """
  def create(conn, user_params) do
    IO.inspect user_params
    if upload = user_params["logo"] do
      extension = Path.extname(upload.filename)
      IO.puts extension
      File.cp!(upload.path, "media/logoextension")
    end
    get_images(user_params["camera"], upload.filename, user_params["position"]) , user_params["header"], user_params["sponsor"], user_params["font"], user_params["color"]
    render conn, "index.html"
  end
  """

  def create(conn, video_params) do
    caller = conn.assigns[:current_user]
    logo = ""
    if upload = video_params["logo"] do
      extension = Path.extname(upload.filename)
      IO.puts extension
      File.cp!(upload.path, "media/logo#{extension}")
      logo = "data:image/jpeg;base64,#{Base.encode64("media/logo#{extension}")}"
    end
    params =
      %{}
      |> add_parameter("field", :watermark_logo, logo)
      |> construct_timelapse_parameters(video_params)
    IO.inspect params
    case Videos.create_video(params, caller) do
      {:ok, video} ->
        conn
        |> get_images(params["camera"], upload.filename, params["position"]) # , user_params["header"], user_params["sponsor"], user_params["font"], user_params["color"]
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Video not created.")
        |> redirect(to: timelapse_path(conn, :index))
    end
  end

  defp construct_timelapse_parameters(timelapse, video_params) do
    timelapse
    |> add_parameter("field", :title, video_params["title"])
    |> add_parameter("field", :status, video_params["status"])
    |> add_parameter("field", :date_always, video_params["date_always"])
    |> add_parameter("field", :description, video_params["description"])
    |> add_parameter("field", :url, video_params["url"])

    |> add_parameter("field", :resolution, video_params["resolution"])
    |> add_parameter("field", :watermark_position, video_params["watermark_position"])

    |> add_parameter("field", :from_datetime, video_params["from_datetime"])
    |> add_parameter("field", :to_datetime, video_params["to_datetime"])
  end

  defp add_parameter(params, _field, _key, nil), do: params
  defp add_parameter(params, "field", key, value) do
    Map.put(params, key, value)
  end

  defp get_images(conn, camera, logo, position) do # , header, sponsor, font, color
    # url = "http://95.216.167.191:5000"
    url = "http://localhost:5000/api"
    req = HTTPoison.post(url,
      {:multipart, [
          {"camera_id", camera},
          {"position", position},
          {:file, "media/logo.png",
            {"form-data", [
                {"name", "\"logo\""},
                {"filename", logo}]},
                []},
          ]})
    case req do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "[good call] [#{body}]"
      {:error, error} ->
        Logger.info "[call] [#{inspect error}]"
    end
  end
end
