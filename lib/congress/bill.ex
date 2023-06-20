defmodule Congress.Bill do
  @moduledoc """
  `Congress.Bill`: fetch bills and bill information.
  """

  @doc """
  Returns a list of bills sorted by date of latest action.

  Optional parameters allow finer control:

   * :congress - limit results to bills in the specified Congress
   * :bill_type - limit results to bills of the specified type

  Note that `:bill_type` requires `:congress`.
  """
  def bills(req, opts \\ []) do
    params = Congress.opts_helper(opts)

    case {Keyword.get(opts, :congress), Keyword.get(opts, :bill_type)} do
      {nil, nil} -> bill_request(req, [], params)
      {nil, _bill_type} -> {:error, "bill_type requires a congress parameter"}
      {congress, nil} -> bill_request(req, [congress], params)
      {congress, bill_type} -> bill_request(req, [congress, bill_type], params)
    end
  end

  @doc """
  Returns detailed information for a specified bill.
  """
  def bill(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number], opts)

  @doc """
  Returns the list of actions on a specified bill.
  """
  def actions(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "actions"], opts)

  @doc """
  Returns the list of amendments to a specified bill.
  """
  def amendments(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "amendments"], opts)

  @doc """
  Returns the list of committees associated with a specified bill.
  """
  def committees(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "committees"], opts)

  @doc """
  Returns the list of cosponsors on a specified bill.
  """
  def cosponsors(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "cosponsors"], opts)

  @doc """
  Returns the list of related bills to a specified bill.
  """
  def related_bills(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "relatedbills"], opts)

  @doc """
  Returns the list of legislative subjects on a specified bill.
  """
  def subjects(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "subjects"], opts)

  @doc """
  Returns the list of summaries for a specified bill.
  """
  def summaries(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "summaries"], opts)

  @doc """
  Returns the list of text versions for a specified bill.
  """
  def text(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "text"], opts)

  @doc """
  Returns the list of titles for a specified bill.
  """
  def titles(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "titles"], opts)

  defp bill_request(req, parts, opts) do
    Congress.request(req, Congress.path(["/v3/bill" | parts]), opts)
  end
end
