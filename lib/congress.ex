defmodule Congress do
  @external_resource "README.md"
  @moduledoc @external_resource
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  @default_base_url "https://api.congress.gov/"
  @default_user_agent "Congress (elixir)/#{Mix.Project.config()[:version]}"
  @default_api_key_env "CONGRESS_API_KEY"

  @doc """
  Creates a new `Congress` client reference, optionally specifying several parameters.

   * :api_key - your API key. uses @default_api_key_env from the environment by default
   * :base_url -  the base url for the API. default: @default_base_url
   * :user_agent - the User-Agent HTTP header value. default: @default_user_agent

  """
  def new(opts \\ []) do
    api_key = Keyword.get(opts, :api_key, System.get_env(@default_api_key_env))
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

  @doc """
  Return the previous page of items, if any. Takes the client reference and a response from 
  any API call that returns a list of items.
  """
  def previous(req, %{pagination: %{prev: prev}}) when prev != nil, do: page(req, prev)
  def previous(_req, _resp), do: {:error, "No previous element"}

  @doc """
  Return the next page of items, if any. Takes the client reference and a response from 
  any API call that returns a list of items.
  """
  def next(req, %{pagination: %{next: next}}) when next != nil, do: page(req, next)
  def next(_req, _resp), do: {:error, "No next element"}

  @doc false
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
