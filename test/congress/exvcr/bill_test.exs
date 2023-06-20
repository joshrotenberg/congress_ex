defmodule Congress.ExVCR.BillTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  setup_all do
    Finch.start_link(name: BillTestFinch)
    api_key = System.get_env("CONGRESS_TEST_API_KEY")
    req = Congress.new(api_key: api_key) |> Req.Request.merge_options(finch: BillTestFinch)
    {:ok, req: req}
  end

  describe "bills" do
    test "get a list of bills", state do
      use_cassette "bill_test_bill_request" do
        {:ok, response} = Congress.Bill.bills(state[:req])
        assert length(response.bills) == 20
      end
    end
  end
end
