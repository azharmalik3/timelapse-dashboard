defmodule Timelapse.Timelapse do
  require Logger

  def get_images(camera, logo, position) do # , header, sponsor, font, color
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
      {:ok, %HTTPoison.Response{status_code: 200, body: data}} -> {:ok, data}
        _error ->
          :not_found
    end
  end
end
