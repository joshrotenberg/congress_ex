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

  describe "bill" do
    test "get a bill", %{req: req} do
      {:ok, response} = Congress.Bill.bill(req, 117, :hr, 3076)
      assert response.bill != nil
    end

    test "get a bill's actions", %{req: req} do
      {:ok, response} = Congress.Bill.actions(req, 117, :hr, 3076)
      assert response.actions != nil
    end

    test "get a bill's amendments", %{req: req} do
      {:ok, response} = Congress.Bill.amendments(req, 117, :hr, 3076)
      assert response.amendments != nil
    end

    test "get a bill's committees", %{req: req} do
      {:ok, response} = Congress.Bill.committees(req, 117, :hr, 3076)
      assert response.committees != nil
    end

    test "get a bill's cosponsors", %{req: req} do
      {:ok, response} = Congress.Bill.cosponsors(req, 117, :hr, 3076)
      assert response.cosponsors != nil
    end

    test "get a bill's related bills", %{req: req} do
      {:ok, response} = Congress.Bill.related_bills(req, 117, :hr, 3076)
      assert response.related_bills != nil
    end

    test "get a bill's subjects", %{req: req} do
      {:ok, response} = Congress.Bill.subjects(req, 117, :hr, 3076)
      assert response.subjects != nil
    end

    test "get a bill's summaries", %{req: req} do
      {:ok, response} = Congress.Bill.summaries(req, 117, :hr, 3076)
      assert response.summaries != nil
    end

    test "get a bill's text", %{req: req} do
      {:ok, response} = Congress.Bill.text(req, 117, :hr, 3076)
      assert response.text_versions != nil
    end

    test "get a bill's titles", %{req: req} do
      {:ok, response} = Congress.Bill.titles(req, 117, :hr, 3076)
      assert response.titles != nil
    end
  end
end
