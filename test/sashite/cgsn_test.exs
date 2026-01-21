defmodule Sashite.CgsnTest do
  use ExUnit.Case, async: true

  doctest Sashite.Cgsn

  # ============================================================================
  # Constants
  # ============================================================================

  describe "constants" do
    test "statuses/0 returns a MapSet" do
      assert %MapSet{} = Sashite.Cgsn.statuses()
    end

    test "statuses/0 contains 14 atoms" do
      assert MapSet.size(Sashite.Cgsn.statuses()) == 14
    end

    test "inferable_statuses/0 returns a MapSet" do
      assert %MapSet{} = Sashite.Cgsn.inferable_statuses()
    end

    test "inferable_statuses/0 contains 8 atoms" do
      assert MapSet.size(Sashite.Cgsn.inferable_statuses()) == 8
    end

    test "explicit_only_statuses/0 returns a MapSet" do
      assert %MapSet{} = Sashite.Cgsn.explicit_only_statuses()
    end

    test "explicit_only_statuses/0 contains 6 atoms" do
      assert MapSet.size(Sashite.Cgsn.explicit_only_statuses()) == 6
    end

    test "statuses/0 is union of inferable and explicit_only" do
      union = MapSet.union(
        Sashite.Cgsn.inferable_statuses(),
        Sashite.Cgsn.explicit_only_statuses()
      )
      assert Sashite.Cgsn.statuses() == union
    end

    test "all statuses are atoms" do
      Sashite.Cgsn.statuses()
      |> Enum.each(fn status ->
        assert is_atom(status)
      end)
    end
  end

  # ============================================================================
  # parse/1
  # ============================================================================

  describe "parse/1" do
    test "parses 'checkmate' to {:ok, :checkmate}" do
      assert {:ok, :checkmate} = Sashite.Cgsn.parse("checkmate")
    end

    test "parses 'resignation' to {:ok, :resignation}" do
      assert {:ok, :resignation} = Sashite.Cgsn.parse("resignation")
    end

    test "parses all inferable statuses" do
      ~w[check stale checkmate stalemate nomove bareking mareking insufficient]
      |> Enum.each(fn str ->
        assert {:ok, atom} = Sashite.Cgsn.parse(str)
        assert atom == String.to_atom(str)
      end)
    end

    test "parses all explicit-only statuses" do
      ~w[resignation illegalmove timelimit movelimit repetition agreement]
      |> Enum.each(fn str ->
        assert {:ok, atom} = Sashite.Cgsn.parse(str)
        assert atom == String.to_atom(str)
      end)
    end

    test "returns {:error, :invalid_status} for invalid status" do
      assert {:error, :invalid_status} = Sashite.Cgsn.parse("invalid")
    end

    test "returns {:error, :invalid_status} for empty string" do
      assert {:error, :invalid_status} = Sashite.Cgsn.parse("")
    end

    test "returns {:error, :invalid_status} for uppercase" do
      assert {:error, :invalid_status} = Sashite.Cgsn.parse("CHECKMATE")
    end

    test "returns {:error, :invalid_status} for mixed case" do
      assert {:error, :invalid_status} = Sashite.Cgsn.parse("Checkmate")
    end

    test "returns {:error, :invalid_status} for nil" do
      assert {:error, :invalid_status} = Sashite.Cgsn.parse(nil)
    end

    test "returns {:error, :invalid_status} for atom" do
      assert {:error, :invalid_status} = Sashite.Cgsn.parse(:checkmate)
    end

    test "returns {:error, :invalid_status} for integer" do
      assert {:error, :invalid_status} = Sashite.Cgsn.parse(123)
    end
  end

  # ============================================================================
  # parse!/1
  # ============================================================================

  describe "parse!/1" do
    test "parses 'checkmate' to :checkmate" do
      assert :checkmate = Sashite.Cgsn.parse!("checkmate")
    end

    test "parses 'resignation' to :resignation" do
      assert :resignation = Sashite.Cgsn.parse!("resignation")
    end

    test "parses all valid statuses" do
      ~w[check stale checkmate stalemate nomove bareking mareking insufficient
         resignation illegalmove timelimit movelimit repetition agreement]
      |> Enum.each(fn str ->
        assert Sashite.Cgsn.parse!(str) == String.to_atom(str)
      end)
    end

    test "raises ArgumentError for invalid status" do
      assert_raise ArgumentError, "invalid status", fn ->
        Sashite.Cgsn.parse!("invalid")
      end
    end

    test "raises ArgumentError for empty string" do
      assert_raise ArgumentError, "invalid status", fn ->
        Sashite.Cgsn.parse!("")
      end
    end

    test "raises ArgumentError for uppercase" do
      assert_raise ArgumentError, "invalid status", fn ->
        Sashite.Cgsn.parse!("CHECKMATE")
      end
    end

    test "raises ArgumentError for mixed case" do
      assert_raise ArgumentError, "invalid status", fn ->
        Sashite.Cgsn.parse!("Checkmate")
      end
    end
  end

  # ============================================================================
  # valid?/1
  # ============================================================================

  describe "valid?/1" do
    test "returns true for all valid statuses" do
      ~w[check stale checkmate stalemate nomove bareking mareking insufficient
         resignation illegalmove timelimit movelimit repetition agreement]
      |> Enum.each(fn str ->
        assert Sashite.Cgsn.valid?(str) == true
      end)
    end

    test "returns false for invalid status" do
      refute Sashite.Cgsn.valid?("invalid")
    end

    test "returns false for empty string" do
      refute Sashite.Cgsn.valid?("")
    end

    test "returns false for uppercase" do
      refute Sashite.Cgsn.valid?("CHECKMATE")
    end

    test "returns false for mixed case" do
      refute Sashite.Cgsn.valid?("Checkmate")
    end

    test "returns false for nil" do
      refute Sashite.Cgsn.valid?(nil)
    end

    test "returns false for atom" do
      refute Sashite.Cgsn.valid?(:checkmate)
    end

    test "returns false for integer" do
      refute Sashite.Cgsn.valid?(123)
    end

    test "returns false for list" do
      refute Sashite.Cgsn.valid?(["checkmate"])
    end

    test "returns false for map" do
      refute Sashite.Cgsn.valid?(%{status: "checkmate"})
    end
  end

  # ============================================================================
  # inferable?/1
  # ============================================================================

  describe "inferable?/1" do
    test "returns true for all inferable statuses" do
      [:check, :stale, :checkmate, :stalemate, :nomove, :bareking, :mareking, :insufficient]
      |> Enum.each(fn status ->
        assert Sashite.Cgsn.inferable?(status) == true
      end)
    end

    test "returns false for explicit-only statuses" do
      [:resignation, :illegalmove, :timelimit, :movelimit, :repetition, :agreement]
      |> Enum.each(fn status ->
        refute Sashite.Cgsn.inferable?(status)
      end)
    end

    test "returns false for invalid atom" do
      refute Sashite.Cgsn.inferable?(:invalid)
    end

    test "returns false for string" do
      refute Sashite.Cgsn.inferable?("checkmate")
    end

    test "returns false for nil" do
      refute Sashite.Cgsn.inferable?(nil)
    end

    test "returns false for integer" do
      refute Sashite.Cgsn.inferable?(123)
    end
  end

  # ============================================================================
  # explicit_only?/1
  # ============================================================================

  describe "explicit_only?/1" do
    test "returns true for all explicit-only statuses" do
      [:resignation, :illegalmove, :timelimit, :movelimit, :repetition, :agreement]
      |> Enum.each(fn status ->
        assert Sashite.Cgsn.explicit_only?(status) == true
      end)
    end

    test "returns false for inferable statuses" do
      [:check, :stale, :checkmate, :stalemate, :nomove, :bareking, :mareking, :insufficient]
      |> Enum.each(fn status ->
        refute Sashite.Cgsn.explicit_only?(status)
      end)
    end

    test "returns false for invalid atom" do
      refute Sashite.Cgsn.explicit_only?(:invalid)
    end

    test "returns false for string" do
      refute Sashite.Cgsn.explicit_only?("resignation")
    end

    test "returns false for nil" do
      refute Sashite.Cgsn.explicit_only?(nil)
    end

    test "returns false for integer" do
      refute Sashite.Cgsn.explicit_only?(123)
    end
  end

  # ============================================================================
  # statuses/0
  # ============================================================================

  describe "statuses/0" do
    test "contains all expected statuses" do
      expected = MapSet.new([
        :check, :stale, :checkmate, :stalemate, :nomove, :bareking, :mareking, :insufficient,
        :resignation, :illegalmove, :timelimit, :movelimit, :repetition, :agreement
      ])
      assert Sashite.Cgsn.statuses() == expected
    end
  end

  # ============================================================================
  # inferable_statuses/0
  # ============================================================================

  describe "inferable_statuses/0" do
    test "contains all expected inferable statuses" do
      expected = MapSet.new([
        :check, :stale, :checkmate, :stalemate, :nomove, :bareking, :mareking, :insufficient
      ])
      assert Sashite.Cgsn.inferable_statuses() == expected
    end
  end

  # ============================================================================
  # explicit_only_statuses/0
  # ============================================================================

  describe "explicit_only_statuses/0" do
    test "contains all expected explicit-only statuses" do
      expected = MapSet.new([
        :resignation, :illegalmove, :timelimit, :movelimit, :repetition, :agreement
      ])
      assert Sashite.Cgsn.explicit_only_statuses() == expected
    end
  end

  # ============================================================================
  # Round-trip tests
  # ============================================================================

  describe "round-trip" do
    test "parse then check inferable" do
      {:ok, status} = Sashite.Cgsn.parse("checkmate")
      assert Sashite.Cgsn.inferable?(status)
    end

    test "parse then check explicit_only" do
      {:ok, status} = Sashite.Cgsn.parse("resignation")
      assert Sashite.Cgsn.explicit_only?(status)
    end

    test "all parsed statuses are in statuses set" do
      ~w[check stale checkmate stalemate nomove bareking mareking insufficient
         resignation illegalmove timelimit movelimit repetition agreement]
      |> Enum.each(fn str ->
        {:ok, status} = Sashite.Cgsn.parse(str)
        assert MapSet.member?(Sashite.Cgsn.statuses(), status)
      end)
    end

    test "parse! then check classification" do
      assert Sashite.Cgsn.inferable?(Sashite.Cgsn.parse!("stalemate"))
      assert Sashite.Cgsn.explicit_only?(Sashite.Cgsn.parse!("timelimit"))
    end
  end
end
