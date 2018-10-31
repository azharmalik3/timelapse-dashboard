defmodule TimelapseWeb.WatchController do
  @moduledoc false

  use TimelapseWeb, :controller

  alias(Timelapse.Videos)

  import Timelapse.Auth, only: [load_current_user: 2]

  plug(:load_current_user)

  def show(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    {:ok, url} = get_presigned_url_to_object(video.url)
    video = Map.put(video, :url, url)
    render(conn, "show.html", video: video)
  end

  def get_presigned_url_to_object(path) do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(:get, "timelapse-server", path)
  end

  defp add_parameter(params, _field, _key, nil), do: params
  defp add_parameter(params, "field", key, value) do
    Map.put(params, key, value)
  end
end
