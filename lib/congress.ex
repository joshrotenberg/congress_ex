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

  def new(api_key, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, @default_base_url)
    user_agent = Keyword.get(opts, :user_agent, @default_user_agent)

    Req.new(
      base_url: base_url,
      user_agent: user_agent,
      method: :get,
      params: [api_key: api_key]
    )
  end
end
