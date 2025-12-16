defmodule Sashite.CgsnTest do
  use ExUnit.Case
  doctest Sashite.Cgsn

  describe "statuses/0" do
    test "returns all defined CGSN status values" do
      statuses = Sashite.Cgsn.statuses()

      assert is_list(statuses)
      assert length(statuses) == 14

      # Verify all expected statuses are present
      expected_statuses = [
        "check",
        "stale",
        "checkmate",
        "stalemate",
        "nomove",
        "bareking",
        "mareking",
        "insufficient",
        "resignation",
        "illegalmove",
        "timelimit",
        "movelimit",
        "repetition",
        "agreement"
      ]

      assert Enum.sort(statuses) == Enum.sort(expected_statuses)
    end

    test "returns inferable and explicit-only statuses combined" do
      all_statuses = Sashite.Cgsn.statuses()
      inferable = Sashite.Cgsn.inferable_statuses()
      explicit_only = Sashite.Cgsn.explicit_only_statuses()

      assert Enum.sort(all_statuses) == Enum.sort(inferable ++ explicit_only)
    end
  end

  describe "inferable_statuses/0" do
    test "returns all position-inferable status values" do
      statuses = Sashite.Cgsn.inferable_statuses()

      assert is_list(statuses)
      assert length(statuses) == 8

      expected_statuses = [
        "check",
        "stale",
        "checkmate",
        "stalemate",
        "nomove",
        "bareking",
        "mareking",
        "insufficient"
      ]

      assert Enum.sort(statuses) == Enum.sort(expected_statuses)
    end
  end

  describe "explicit_only_statuses/0" do
    test "returns all explicit-only status values" do
      statuses = Sashite.Cgsn.explicit_only_statuses()

      assert is_list(statuses)
      assert length(statuses) == 6

      expected_statuses = [
        "resignation",
        "illegalmove",
        "timelimit",
        "movelimit",
        "repetition",
        "agreement"
      ]

      assert Enum.sort(statuses) == Enum.sort(expected_statuses)
    end
  end

  describe "valid?/1" do
    test "returns true for all inferable statuses" do
      Sashite.Cgsn.inferable_statuses()
      |> Enum.each(fn status ->
        assert Sashite.Cgsn.valid?(status), "Expected #{status} to be valid"
      end)
    end

    test "returns true for all explicit-only statuses" do
      Sashite.Cgsn.explicit_only_statuses()
      |> Enum.each(fn status ->
        assert Sashite.Cgsn.valid?(status), "Expected #{status} to be valid"
      end)
    end

    test "returns true for specific valid statuses" do
      assert Sashite.Cgsn.valid?("checkmate")
      assert Sashite.Cgsn.valid?("resignation")
      assert Sashite.Cgsn.valid?("stalemate")
      assert Sashite.Cgsn.valid?("timelimit")
    end

    test "returns false for invalid statuses" do
      refute Sashite.Cgsn.valid?("invalid")
      refute Sashite.Cgsn.valid?("check_mate")
      refute Sashite.Cgsn.valid?("CHECKMATE")
      refute Sashite.Cgsn.valid?("Check")
      refute Sashite.Cgsn.valid?("unknown")
    end

    test "returns false for empty string" do
      refute Sashite.Cgsn.valid?("")
    end

    test "returns false for nil" do
      refute Sashite.Cgsn.valid?(nil)
    end

    test "returns false for non-string types" do
      refute Sashite.Cgsn.valid?(123)
      refute Sashite.Cgsn.valid?(:checkmate)
      refute Sashite.Cgsn.valid?(%{})
      refute Sashite.Cgsn.valid?([])
    end
  end

  describe "inferable?/1" do
    test "returns true for all inferable statuses" do
      inferable_statuses = [
        "check",
        "stale",
        "checkmate",
        "stalemate",
        "nomove",
        "bareking",
        "mareking",
        "insufficient"
      ]

      Enum.each(inferable_statuses, fn status ->
        assert Sashite.Cgsn.inferable?(status), "Expected #{status} to be inferable"
      end)
    end

    test "returns false for all explicit-only statuses" do
      explicit_only_statuses = [
        "resignation",
        "illegalmove",
        "timelimit",
        "movelimit",
        "repetition",
        "agreement"
      ]

      Enum.each(explicit_only_statuses, fn status ->
        refute Sashite.Cgsn.inferable?(status), "Expected #{status} not to be inferable"
      end)
    end

    test "returns false for invalid statuses" do
      refute Sashite.Cgsn.inferable?("invalid")
      refute Sashite.Cgsn.inferable?("unknown")
    end

    test "returns false for empty string" do
      refute Sashite.Cgsn.inferable?("")
    end

    test "returns false for nil" do
      refute Sashite.Cgsn.inferable?(nil)
    end

    test "returns false for non-string types" do
      refute Sashite.Cgsn.inferable?(123)
      refute Sashite.Cgsn.inferable?(:checkmate)
    end
  end

  describe "explicit_only?/1" do
    test "returns true for all explicit-only statuses" do
      explicit_only_statuses = [
        "resignation",
        "illegalmove",
        "timelimit",
        "movelimit",
        "repetition",
        "agreement"
      ]

      Enum.each(explicit_only_statuses, fn status ->
        assert Sashite.Cgsn.explicit_only?(status), "Expected #{status} to be explicit-only"
      end)
    end

    test "returns false for all inferable statuses" do
      inferable_statuses = [
        "check",
        "stale",
        "checkmate",
        "stalemate",
        "nomove",
        "bareking",
        "mareking",
        "insufficient"
      ]

      Enum.each(inferable_statuses, fn status ->
        refute Sashite.Cgsn.explicit_only?(status),
               "Expected #{status} not to be explicit-only"
      end)
    end

    test "returns false for invalid statuses" do
      refute Sashite.Cgsn.explicit_only?("invalid")
      refute Sashite.Cgsn.explicit_only?("unknown")
    end

    test "returns false for empty string" do
      refute Sashite.Cgsn.explicit_only?("")
    end

    test "returns false for nil" do
      refute Sashite.Cgsn.explicit_only?(nil)
    end

    test "returns false for non-string types" do
      refute Sashite.Cgsn.explicit_only?(123)
      refute Sashite.Cgsn.explicit_only?(:resignation)
    end
  end

  describe "categorization consistency" do
    test "every status is either inferable or explicit-only, not both" do
      Sashite.Cgsn.statuses()
      |> Enum.each(fn status ->
        is_inferable = Sashite.Cgsn.inferable?(status)
        is_explicit_only = Sashite.Cgsn.explicit_only?(status)

        assert is_inferable != is_explicit_only,
               "Status #{status} must be exactly one of: inferable or explicit-only"
      end)
    end

    test "every status is valid" do
      Sashite.Cgsn.statuses()
      |> Enum.each(fn status ->
        assert Sashite.Cgsn.valid?(status), "Expected #{status} to be valid"
      end)
    end
  end

  describe "game examples" do
    test "Western Chess - Scholar's Mate" do
      assert Sashite.Cgsn.valid?("checkmate")
      assert Sashite.Cgsn.inferable?("checkmate")
      refute Sashite.Cgsn.explicit_only?("checkmate")
    end

    test "Western Chess - resignation" do
      assert Sashite.Cgsn.valid?("resignation")
      refute Sashite.Cgsn.inferable?("resignation")
      assert Sashite.Cgsn.explicit_only?("resignation")
    end

    test "Shōgi - tsume (checkmate)" do
      assert Sashite.Cgsn.valid?("checkmate")
      assert Sashite.Cgsn.inferable?("checkmate")
    end

    test "Shōgi - sennichite (repetition)" do
      assert Sashite.Cgsn.valid?("repetition")
      refute Sashite.Cgsn.inferable?("repetition")
      assert Sashite.Cgsn.explicit_only?("repetition")
    end

    test "Xiangqi - jiāng-jūn (check)" do
      assert Sashite.Cgsn.valid?("check")
      assert Sashite.Cgsn.inferable?("check")
    end

    test "Xiangqi - bare king" do
      assert Sashite.Cgsn.valid?("bareking")
      assert Sashite.Cgsn.inferable?("bareking")
    end
  end
end
