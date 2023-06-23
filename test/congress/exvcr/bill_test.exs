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
    test "get a list of bills", %{req: req} do
      use_cassette "bill_test_bills_request" do
        {:ok, response} = Congress.Bill.bills(req)
        assert length(response.bills) == 20
      end
    end

    test "get a list of bills with the specified congress", %{req: req} do
      use_cassette "bill_test_bills_with_congress_request" do
        {:ok, response} = Congress.Bill.bills(req, congress: 117)
        assert length(response.bills) == 20
      end
    end

    test "get a list of bills with the specified congress and bill type", %{req: req} do
      use_cassette "bill_test_bills_with_congress_and_bill_type_request" do
        {:ok, response} = Congress.Bill.bills(req, congress: 117, bill_type: :hr)
        assert length(response.bills) == 20
      end
    end
  end
end
