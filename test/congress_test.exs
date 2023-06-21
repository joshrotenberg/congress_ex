defmodule CongressTest do
  use ExUnit.Case
  doctest Congress

  describe "test Congress" do
    test "new" do
      options = Congress.new().options
      assert options.base_url == "https://api.congress.gov/"
      assert options.user_agent == "Congress (elixir)/0.1.0"
    end
  end
end
