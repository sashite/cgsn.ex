defmodule Sashite.Cgsn do
  @moduledoc """
  CGSN (Chess Game Status Notation) implementation for Elixir.

  CGSN provides a rule-agnostic taxonomy of observable game status values
  for abstract strategy board games. Status values are categorized as either
  position-inferable (derivable from board position) or explicit-only
  (requiring external information like history or declarations).

  ## Examples

      iex> Sashite.Cgsn.valid?("checkmate")
      true

      iex> Sashite.Cgsn.inferable?("checkmate")
      true

      iex> Sashite.Cgsn.explicit_only?("resignation")
      true

  """

  @inferable_statuses [
    "check",
    "stale",
    "checkmate",
    "stalemate",
    "nomove",
    "bareking",
    "mareking",
    "insufficient"
  ]

  @explicit_only_statuses [
    "resignation",
    "illegalmove",
    "timelimit",
    "movelimit",
    "repetition",
    "agreement"
  ]

  @statuses @inferable_statuses ++ @explicit_only_statuses

  @type status :: String.t()

  @doc """
  Returns all defined CGSN status values.

  ## Examples

      iex> Sashite.Cgsn.statuses()
      ["check", "stale", "checkmate", "stalemate", "nomove", "bareking",
       "mareking", "insufficient", "resignation", "illegalmove", "timelimit",
       "movelimit", "repetition", "agreement"]

  """
  @spec statuses() :: [status()]
  def statuses, do: @statuses

  @doc """
  Returns all position-inferable status values.

  Position-inferable statuses can be determined from position analysis
  when game rules are known.

  ## Examples

      iex> Sashite.Cgsn.inferable_statuses()
      ["check", "stale", "checkmate", "stalemate", "nomove", "bareking",
       "mareking", "insufficient"]

  """
  @spec inferable_statuses() :: [status()]
  def inferable_statuses, do: @inferable_statuses

  @doc """
  Returns all explicit-only status values.

  Explicit-only statuses require external information (history, clocks,
  declarations) and cannot be derived from position alone.

  ## Examples

      iex> Sashite.Cgsn.explicit_only_statuses()
      ["resignation", "illegalmove", "timelimit", "movelimit", "repetition",
       "agreement"]

  """
  @spec explicit_only_statuses() :: [status()]
  def explicit_only_statuses, do: @explicit_only_statuses

  @doc """
  Checks if the given value is a valid CGSN status.

  ## Parameters

    - `status` - The status string to validate

  ## Examples

      iex> Sashite.Cgsn.valid?("checkmate")
      true

      iex> Sashite.Cgsn.valid?("resignation")
      true

      iex> Sashite.Cgsn.valid?("invalid")
      false

      iex> Sashite.Cgsn.valid?("")
      false

      iex> Sashite.Cgsn.valid?(nil)
      false

  """
  @spec valid?(any()) :: boolean()
  def valid?(status) when is_binary(status) do
    status in @statuses
  end

  def valid?(_), do: false

  @doc """
  Checks if the given status is position-inferable.

  Returns `true` if the status can be determined from position analysis
  when game rules are known, `false` otherwise.

  ## Parameters

    - `status` - The status string to check

  ## Examples

      iex> Sashite.Cgsn.inferable?("checkmate")
      true

      iex> Sashite.Cgsn.inferable?("stalemate")
      true

      iex> Sashite.Cgsn.inferable?("resignation")
      false

      iex> Sashite.Cgsn.inferable?("invalid")
      false

  """
  @spec inferable?(any()) :: boolean()
  def inferable?(status) when is_binary(status) do
    status in @inferable_statuses
  end

  def inferable?(_), do: false

  @doc """
  Checks if the given status is explicit-only.

  Returns `true` if the status requires external information (history,
  clocks, declarations) and cannot be derived from position alone,
  `false` otherwise.

  ## Parameters

    - `status` - The status string to check

  ## Examples

      iex> Sashite.Cgsn.explicit_only?("resignation")
      true

      iex> Sashite.Cgsn.explicit_only?("timelimit")
      true

      iex> Sashite.Cgsn.explicit_only?("checkmate")
      false

      iex> Sashite.Cgsn.explicit_only?("invalid")
      false

  """
  @spec explicit_only?(any()) :: boolean()
  def explicit_only?(status) when is_binary(status) do
    status in @explicit_only_statuses
  end

  def explicit_only?(_), do: false
end
