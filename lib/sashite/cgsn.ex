defmodule Sashite.Cgsn do
  @moduledoc """
  CGSN (Chess Game Status Notation) implementation for Elixir.

  Provides a rule-agnostic vocabulary for identifying game statuses
  in abstract strategy board games with atom-based identifiers.

  ## Examples

      iex> Sashite.Cgsn.parse("checkmate")
      {:ok, :checkmate}

      iex> Sashite.Cgsn.valid?("checkmate")
      true

      iex> Sashite.Cgsn.inferable?(:checkmate)
      true

      iex> Sashite.Cgsn.explicit_only?(:resignation)
      true

  See: https://sashite.dev/specs/cgsn/1.0.0/
  """

  @inferable_statuses MapSet.new([
    :check,
    :stale,
    :checkmate,
    :stalemate,
    :nomove,
    :bareking,
    :mareking,
    :insufficient
  ])

  @explicit_only_statuses MapSet.new([
    :resignation,
    :illegalmove,
    :timelimit,
    :movelimit,
    :repetition,
    :agreement
  ])

  @statuses MapSet.union(@inferable_statuses, @explicit_only_statuses)

  @valid_strings @statuses |> Enum.map(&Atom.to_string/1) |> MapSet.new()

  # ==========================================================================
  # Parsing
  # ==========================================================================

  @doc """
  Parses a CGSN string into an atom.

  ## Parameters

  - `input` - The CGSN status string to parse

  ## Returns

  - `{:ok, atom}` on success
  - `{:error, :invalid_status}` on failure

  ## Examples

      iex> Sashite.Cgsn.parse("checkmate")
      {:ok, :checkmate}

      iex> Sashite.Cgsn.parse("resignation")
      {:ok, :resignation}

      iex> Sashite.Cgsn.parse("invalid")
      {:error, :invalid_status}

      iex> Sashite.Cgsn.parse("")
      {:error, :invalid_status}
  """
  @spec parse(String.t()) :: {:ok, atom()} | {:error, :invalid_status}
  def parse(input) when is_binary(input) do
    if MapSet.member?(@valid_strings, input) do
      {:ok, String.to_existing_atom(input)}
    else
      {:error, :invalid_status}
    end
  end

  def parse(_), do: {:error, :invalid_status}

  @doc """
  Parses a CGSN string into an atom, raising on error.

  ## Parameters

  - `input` - The CGSN status string to parse

  ## Returns

  The corresponding status atom.

  ## Raises

  - `ArgumentError` if the input is invalid

  ## Examples

      iex> Sashite.Cgsn.parse!("checkmate")
      :checkmate

      iex> Sashite.Cgsn.parse!("resignation")
      :resignation
  """
  @spec parse!(String.t()) :: atom()
  def parse!(input) do
    case parse(input) do
      {:ok, status} -> status
      {:error, :invalid_status} -> raise ArgumentError, "invalid status"
    end
  end

  # ==========================================================================
  # Validation
  # ==========================================================================

  @doc """
  Reports whether the input is a valid CGSN status string.

  ## Parameters

  - `input` - The value to check

  ## Returns

  `true` if valid, `false` otherwise.

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
  @spec valid?(term()) :: boolean()
  def valid?(input) when is_binary(input) do
    MapSet.member?(@valid_strings, input)
  end

  def valid?(_), do: false

  # ==========================================================================
  # Classification
  # ==========================================================================

  @doc """
  Reports whether the status is position-inferable.

  Position-inferable statuses can be determined from Position + Rule System
  without external context (history, clocks, declarations).

  ## Parameters

  - `status` - The status atom to check

  ## Returns

  `true` if position-inferable, `false` otherwise.

  ## Examples

      iex> Sashite.Cgsn.inferable?(:checkmate)
      true

      iex> Sashite.Cgsn.inferable?(:stalemate)
      true

      iex> Sashite.Cgsn.inferable?(:repetition)
      false

      iex> Sashite.Cgsn.inferable?(:invalid)
      false
  """
  @spec inferable?(atom()) :: boolean()
  def inferable?(status) when is_atom(status) do
    MapSet.member?(@inferable_statuses, status)
  end

  def inferable?(_), do: false

  @doc """
  Reports whether the status is explicit-only.

  Explicit-only statuses require external context (history, clocks,
  declarations) and cannot be derived from Position + Rule System alone.

  ## Parameters

  - `status` - The status atom to check

  ## Returns

  `true` if explicit-only, `false` otherwise.

  ## Examples

      iex> Sashite.Cgsn.explicit_only?(:resignation)
      true

      iex> Sashite.Cgsn.explicit_only?(:timelimit)
      true

      iex> Sashite.Cgsn.explicit_only?(:checkmate)
      false

      iex> Sashite.Cgsn.explicit_only?(:invalid)
      false
  """
  @spec explicit_only?(atom()) :: boolean()
  def explicit_only?(status) when is_atom(status) do
    MapSet.member?(@explicit_only_statuses, status)
  end

  def explicit_only?(_), do: false

  # ==========================================================================
  # Listing
  # ==========================================================================

  @dialyzer {:nowarn_function, [statuses: 0, inferable_statuses: 0, explicit_only_statuses: 0]}

  @doc """
  Returns all CGSN v1.0.0 status atoms.

  ## Returns

  A MapSet of all 14 status atoms.

  ## Examples

      iex> Sashite.Cgsn.statuses() |> MapSet.size()
      14

      iex> Sashite.Cgsn.statuses() |> MapSet.member?(:checkmate)
      true
  """
  @spec statuses() :: MapSet.t()
  def statuses, do: @statuses

  @doc """
  Returns position-inferable status atoms.

  ## Returns

  A MapSet of 8 position-inferable status atoms.

  ## Examples

      iex> Sashite.Cgsn.inferable_statuses() |> MapSet.size()
      8

      iex> Sashite.Cgsn.inferable_statuses() |> MapSet.member?(:checkmate)
      true
  """
  @spec inferable_statuses() :: MapSet.t()
  def inferable_statuses, do: @inferable_statuses

  @doc """
  Returns explicit-only status atoms.

  ## Returns

  A MapSet of 6 explicit-only status atoms.

  ## Examples

      iex> Sashite.Cgsn.explicit_only_statuses() |> MapSet.size()
      6

      iex> Sashite.Cgsn.explicit_only_statuses() |> MapSet.member?(:resignation)
      true
  """
  @spec explicit_only_statuses() :: MapSet.t()
  def explicit_only_statuses, do: @explicit_only_statuses
end
