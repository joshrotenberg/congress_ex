defmodule Congress do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  @default_base_url "https://api.congress.gov/v3/"
  @user_agent "Congress (elixir)/#{Mix.Project.config()[:version]}"

  @moduledoc """
  Documentation for `Congress`.
  """

  def new(api_key, base_url \\ @default_base_url) do
    Req.new()
  end
end
