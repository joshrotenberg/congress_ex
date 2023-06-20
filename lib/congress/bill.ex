defmodule Congress.Bill do
  @moduledoc """
  `Congress.Bill`: fetch bills and bill information.
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

  def bill(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number], opts)

  def actions(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "actions"], opts)

  def amendments(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "amendments"], opts)

  def committees(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "committees"], opts)

  def cosponsors(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "cosponsors"], opts)

  def related_bills(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "relatedbills"], opts)

  def subjects(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "subjects"], opts)

  def summaries(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "summaries"], opts)

  def text(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "text"], opts)

  def titles(req, congress, bill_type, bill_number, opts \\ []),
    do: bill_request(req, [congress, bill_type, bill_number, "titles"], opts)

  defp bill_request(req, parts, opts) do
    Congress.request(req, Congress.path(["/v3/bill" | parts]), opts)
  end
end
