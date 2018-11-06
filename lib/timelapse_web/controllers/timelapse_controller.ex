defmodule TimelapseWeb.TimelapseController do

  require Logger
  use TimelapseWeb, :controller
  import Timelapse.Auth, only: [load_current_user: 2]
  alias Timelapse.Videos
  alias Timelapse.Timelapse
  alias Timelapse.Videos.Video
  import Mogrify

  plug(:load_current_user)

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, video_params) do
    caller = conn.assigns[:current_user]
    if upload = video_params["watermark_logo"] do
      extension = Path.extname(upload.filename)
      File.cp!(upload.path, "media/logo#{extension}")
    end
    case File.read("media/logo.png") do
      {:ok, res} ->
        # Map.put(video_params, :watermark_logo, "data:image/png;base64,#{Base.encode64(res)}")
        case Timelapse.get_images(video_params["camera"], upload.filename, video_params["watermark_position"]) do # , user_params["header"], user_params["sponsor"], user_params["font"], user_params["color"]
          {:ok, data} ->
            IO.inspect(data)
            logo = "data:image/png;base64,#{Base.encode64(res)}"
            url = data <> "-" <> video_params["camera"] <> ".mp4"
            params =
              %{}
              |> construct_timelapse_parameters(logo, url, video_params)
            case Videos.create_video(params, caller) do
              {:ok, video} ->
                conn
                |> put_flash(:info, "Video created successfully.")
                |> redirect(to: video_path(conn, :show, video))
              {:error, %Ecto.Changeset{} = changeset} ->
                conn
                |> put_flash(:error, "Video not created.")
                |> redirect(to: "/timelapse")
            end
          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:error, "Video not created.")
            |> redirect(to: "/timelapse")
        end
      {:error, error} ->
        Logger.info "[call] [#{inspect error}]"
    end
  end

  defp construct_timelapse_parameters(timelapse, logo, url, video_params) do
    timelapse
    |> add_parameter("field", :title, video_params["title"])
    |> add_parameter("field", :status, video_params["status"])
    |> add_parameter("field", :date_always, video_params["date_always"])
    |> add_parameter("field", :description, video_params["description"])
    |> add_parameter("field", :url, url)
    |> add_parameter("field", :camera, video_params["camera"])
    |> add_parameter("field", :frequency, 4)

    |> add_parameter("field", :resolution, video_params["resolution"])
    |> add_parameter("field", :watermark_position, video_params["watermark_position"])
    |> add_parameter("field", :watermark_logo, logo)

    |> add_parameter("field", :from_datetime, video_params["from_datetime"])
    |> add_parameter("field", :to_datetime, video_params["to_datetime"])
  end

  defp add_parameter(params, _field, _key, nil), do: params
  defp add_parameter(params, "field", key, value) do
    Map.put(params, key, value)
  end
end
