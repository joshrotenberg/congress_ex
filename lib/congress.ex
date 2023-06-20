defmodule Congress do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  @default_base_url "https://api.congress.gov/"
  @default_user_agent "Congress (elixir)/#{Mix.Project.config()[:version]}"
  @default_api_key_env "CONGRESS_API_KEY"

  def new() do
    api_key = System.get_env(@default_api_key_env)
    new(api_key)
  end

  def new(api_key, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, @default_base_url)
    user_agent = Keyword.get(opts, :user_agent, @default_user_agent)

    Req.new(
      base_url: base_url,
      user_agent: user_agent,
      method: :get,
      params: [api_key: api_key],
      decode_json: [keys: fn key -> key |> Recase.to_snake() |> String.to_atom() end],
      compressed: true
    )
  end

  def previous(req, %{pagination: %{prev: prev}}) when prev != nil, do: page(req, prev)
  def previous(_req, _resp), do: {:error, "No previous element"}

  def next(req, %{pagination: %{next: next}}) when next != nil, do: page(req, next)
  def next(_req, _resp), do: {:error, "No next element"}

  defp page(req, url) do
    uri = url |> URI.parse()
    query = URI.decode_query(uri.query) |> Map.to_list()
    request(req, uri.path, query)
  end

  @doc false
  def path(parts), do: Enum.map_join(parts, "/", &to_string/1)

  @doc false
  def request(req, path, params) do
    req = update_in(req.options.params, &(&1 ++ params))

    with {:ok, response} <-
           Req.request(req, url: path),
         status <- response.status do
      case status do
        200 -> {:ok, response.body}
        _ -> {:error, response.body.error}
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc false
  def opts_helper(opts) do
    offset = Keyword.get(opts, :offset)
    limit = Keyword.get(opts, :limit)
    from_date_time = Keyword.get(opts, :from_date_time)
    to_date_time = Keyword.get(opts, :to_date_time)
    sort = Keyword.get(opts, :sort)

    [
      offset: offset,
      limit: limit,
      from_date_time: from_date_time,
      to_date_time: to_date_time,
      sort: sort
    ]
    |> Enum.filter(fn {_, v} -> v != nil end)
  end
end
