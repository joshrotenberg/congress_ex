defmodule Congress.BillTest do
  @moduledoc false

  use ExUnit.Case, async: false

  setup_all do
    api_key = System.get_env("CONGRESS_TEST_API_KEY")
    req = Congress.new(api_key)
    {:ok, req: req}
  end

  describe "bills" do
    test "get a list of bills", state do
      {:ok, response} = Congress.Bill.bills(state[:req])
      assert length(response.bills) > 0
    end

    test "get a list of bills with the specified congress", state do
      {:ok, response} = Congress.Bill.bills(state[:req], congress: 117)
      assert length(response.bills) > 0
    end

    test "get a list of bills with the specified congress and bill type", state do
      {:ok, response} = Congress.Bill.bills(state[:req], congress: 117, bill_type: :hr)
      assert length(response.bills) > 0
    end
  end

  describe "bill" do
    test "get a bill", state do
      {:ok, response} = Congress.Bill.bill(state[:req], 117, :hr, 3076)
      assert response.bill != nil
    end

    test "get a bill's actions", state do
      {:ok, response} = Congress.Bill.actions(state[:req], 117, :hr, 3076)
      assert response.actions != nil
    end

    test "get a bill's amendments", state do
      {:ok, response} = Congress.Bill.amendments(state[:req], 117, :hr, 3076)
      assert response.amendments != nil
    end

    test "get a bill's committees", state do
      {:ok, response} = Congress.Bill.committees(state[:req], 117, :hr, 3076)
      assert response.committees != nil
    end

    test "get a bill's cosponsors", state do
      {:ok, response} = Congress.Bill.cosponsors(state[:req], 117, :hr, 3076)
      assert response.cosponsors != nil
    end

    test "get a bill's related bills", state do
      {:ok, response} = Congress.Bill.related_bills(state[:req], 117, :hr, 3076)
      assert response.related_bills != nil
    end

    test "get a bill's subjects", state do
      {:ok, response} = Congress.Bill.subjects(state[:req], 117, :hr, 3076)
      assert response.subjects != nil
    end

    test "get a bill's summaries", state do
      {:ok, response} = Congress.Bill.summaries(state[:req], 117, :hr, 3076)
      assert response.summaries != nil
    end

    test "get a bill's text", state do
      {:ok, response} = Congress.Bill.text(state[:req], 117, :hr, 3076)
      assert response.text_versions != nil
    end

    test "get a bill's titles", state do
      {:ok, response} = Congress.Bill.titles(state[:req], 117, :hr, 3076)
      assert response.titles != nil
    end
  end
end
