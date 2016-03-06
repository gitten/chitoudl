defmodule Chitoudl.PageController do
  use Chitoudl.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
