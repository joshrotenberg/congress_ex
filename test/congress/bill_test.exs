defmodule Congress.BillTest do
  @moduledoc false

  use ExUnit.Case, async: false

  setup_all do
    api_key = System.get_env("CONGRESS_TEST_API_KEY")
    req = Congress.new(api_key: api_key)
    {:ok, req: req}
  end

  describe "bills" do
    test "get a list of bills", %{req: req} do
      {:ok, response} = Congress.Bill.bills(req)
      assert length(response.bills) > 0
    end

    test "get a list of bills with the specified congress", %{req: req} do
      {:ok, response} = Congress.Bill.bills(req, congress: 117)
      assert length(response.bills) > 0
    end

    test "get a list of bills with the specified congress and bill type", %{req: req} do
      {:ok, response} = Congress.Bill.bills(req, congress: 117, bill_type: :hr)
      assert length(response.bills) > 0
    end

    test "bill pagination ", %{req: req} do
      {:ok, response} = Congress.Bill.bills(req, congress: 117)
      assert Congress.previous(req, response) == nil
      assert Congress.next(req, response) != nil

      {:ok, response} = Congress.Bill.bills(req, congress: 117, offset: 2)
      assert Congress.previous(req, response) != nil
      assert Congress.next(req, response) != nil

      {:ok, response} = Congress.Bill.bills(req, congress: 117, offset: 211_000)
      assert Congress.previous(req, response) != nil
      assert Congress.next(req, response) == nil
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
