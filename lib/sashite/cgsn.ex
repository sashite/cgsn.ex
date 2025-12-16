defmodule Sashite.Cgsn do
  @moduledoc """
  CGSN (Chess Game Status Notation) vocabulary for Elixir.

  This module exposes the **CGSN v1.0.0** standard status identifiers (as strings)
  and helpers to validate / classify them.

  CGSN statuses are categorized as either:

  - **position-inferable**: can be determined from *Position + Rule System*,
  - **explicit-only**: require extra context (history, clocks, declarations, etc.).

  This implementation is intentionally **rule-agnostic** and **does not compute**
  game statuses. It only provides a stable vocabulary and membership checks.

  Specification:
  https://sashite.dev/specs/cgsn/1.0.0/

  ## Notes

  - Some statuses (e.g. `check`, `stalemate`) are defined **per Terminal Piece** in the spec.
    Associating such a status with a specific piece belongs to the surrounding protocol / notation.
  - While the spec allows extensions, this module validates only the **standard v1.0.0 vocabulary**.

  ## Examples

      iex> Sashite.Cgsn.valid?("checkmate")
      true

      iex> Sashite.Cgsn.inferable?("checkmate")
      true

      iex> Sashite.Cgsn.explicit_only?("resignation")
      true

      iex> Sashite.Cgsn.valid?("custom-status")
      false
  """

  @typedoc """
  A CGSN status identifier (string).

  This module recognizes only the CGSN v1.0.0 standard vocabulary.
  """
  @type status :: String.t()

  # NOTE: Keep ordering stable and aligned with the specification's complete status list.
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

  # Fast membership checks (compile-time constants).
  @inferable_set MapSet.new(@inferable_statuses)
  @explicit_only_set MapSet.new(@explicit_only_statuses)
  @status_set MapSet.new(@statuses)

  @doc """
  Returns all **CGSN v1.0.0** status identifiers.

  The returned list has a stable order.
  """
  @spec statuses() :: [status()]
  def statuses, do: @statuses

  @doc """
  Returns all **position-inferable** CGSN v1.0.0 status identifiers.

  “Position-inferable” means: given the **current Position** and the **Rule System**,
  the status can be determined without external context (history, clocks, declarations, …).
  """
  @spec inferable_statuses() :: [status()]
  def inferable_statuses, do: @inferable_statuses

  @doc """
  Returns all **explicit-only** CGSN v1.0.0 status identifiers.

  “Explicit-only” means: the status cannot be derived from *Position + Rule System* alone
  because it requires external context (history, clocks, declarations, …).
  """
  @spec explicit_only_statuses() :: [status()]
  def explicit_only_statuses, do: @explicit_only_statuses

  @doc """
  Checks whether the given value is a **standard CGSN v1.0.0** status identifier.

  This function is intentionally strict: it validates membership in the official
  CGSN v1.0.0 vocabulary. It does **not** validate or accept non-standard extensions.
  """
  @spec valid?(any()) :: boolean()
  def valid?(status) when is_binary(status) do
    MapSet.member?(@status_set, status)
  end

  def valid?(_), do: false

  @doc """
  Checks whether the given status is **position-inferable** in CGSN v1.0.0.

  Returns `false` for non-binary inputs and unknown identifiers.
  """
  @spec inferable?(any()) :: boolean()
  def inferable?(status) when is_binary(status) do
    MapSet.member?(@inferable_set, status)
  end

  def inferable?(_), do: false

  @doc """
  Checks whether the given status is **explicit-only** in CGSN v1.0.0.

  Returns `false` for non-binary inputs and unknown identifiers.
  """
  @spec explicit_only?(any()) :: boolean()
  def explicit_only?(status) when is_binary(status) do
    MapSet.member?(@explicit_only_set, status)
  end

  def explicit_only?(_), do: false
end
