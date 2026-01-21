# cgsn.ex

[![Hex.pm](https://img.shields.io/hexpm/v/sashite_cgsn.svg)](https://hex.pm/packages/sashite_cgsn)
[![Docs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/sashite_cgsn)
[![License](https://img.shields.io/hexpm/l/sashite_cgsn.svg)](https://github.com/sashite/cgsn.ex/blob/main/LICENSE)

> **CGSN** (Chess Game Status Notation) implementation for Elixir.

## Overview

This library implements the [CGSN Specification v1.0.0](https://sashite.dev/specs/cgsn/1.0.0/).

## Installation

Add `sashite_cgsn` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sashite_cgsn, "~> 1.1"}
  ]
end
```

## Usage

### Parsing (String → Atom)

Convert a CGSN string into an atom.

```elixir
# Standard parsing (returns {:ok, atom} or {:error, reason})
{:ok, :checkmate} = Sashite.Cgsn.parse("checkmate")
{:ok, :resignation} = Sashite.Cgsn.parse("resignation")

# Bang version (raises on error)
:checkmate = Sashite.Cgsn.parse!("checkmate")

# Invalid input
{:error, :invalid_status} = Sashite.Cgsn.parse("invalid")
{:error, :invalid_status} = Sashite.Cgsn.parse("")
```

### Validation

```elixir
# Boolean check
Sashite.Cgsn.valid?("checkmate")    # => true
Sashite.Cgsn.valid?("resignation")  # => true
Sashite.Cgsn.valid?("invalid")      # => false
Sashite.Cgsn.valid?("")             # => false
Sashite.Cgsn.valid?(nil)            # => false
```

### Classification

```elixir
# Position-inferable: can be determined from Position + Rule System
Sashite.Cgsn.inferable?(:checkmate)   # => true
Sashite.Cgsn.inferable?(:stalemate)   # => true
Sashite.Cgsn.inferable?(:repetition)  # => false

# Explicit-only: requires external context (history, clocks, declarations)
Sashite.Cgsn.explicit_only?(:resignation)  # => true
Sashite.Cgsn.explicit_only?(:timelimit)    # => true
Sashite.Cgsn.explicit_only?(:checkmate)    # => false
```

### Accessing Statuses

```elixir
# All statuses (unordered)
Sashite.Cgsn.statuses()
# => MapSet.new([:check, :stale, :checkmate, :stalemate, :nomove, :bareking,
#                :mareking, :insufficient, :resignation, :illegalmove, :timelimit,
#                :movelimit, :repetition, :agreement])

# Position-inferable statuses
Sashite.Cgsn.inferable_statuses()
# => MapSet.new([:check, :stale, :checkmate, :stalemate, :nomove, :bareking,
#                :mareking, :insufficient])

# Explicit-only statuses
Sashite.Cgsn.explicit_only_statuses()
# => MapSet.new([:resignation, :illegalmove, :timelimit, :movelimit, :repetition,
#                :agreement])
```

## API Reference

### Constants

```elixir
Sashite.Cgsn.statuses()               # MapSet of all 14 status atoms
Sashite.Cgsn.inferable_statuses()     # MapSet of 8 position-inferable atoms
Sashite.Cgsn.explicit_only_statuses() # MapSet of 6 explicit-only atoms
```

### Parsing

```elixir
# Parses a CGSN string into an atom.
# Returns {:ok, atom} or {:error, :invalid_status}.
@spec parse(String.t()) :: {:ok, atom()} | {:error, :invalid_status}

# Parses a CGSN string into an atom.
# Raises ArgumentError if the string is not valid.
@spec parse!(String.t()) :: atom()
```

### Validation

```elixir
# Reports whether string is a valid CGSN status identifier.
@spec valid?(term()) :: boolean()
```

### Classification

```elixir
# Reports whether status is position-inferable.
@spec inferable?(atom()) :: boolean()

# Reports whether status is explicit-only.
@spec explicit_only?(atom()) :: boolean()
```

### Errors

| Error | Cause |
|-------|-------|
| `{:error, :invalid_status}` | Input is not a valid CGSN status |
| `ArgumentError` | Bang function with invalid input |

## Design Principles

- **Atom-based**: Statuses represented as Elixir atoms for identity semantics
- **MapSet-based**: Unordered collections reflect vocabulary nature
- **Elixir idioms**: `{:ok, _}` / `{:error, _}` tuples, `parse!` bang variant
- **Strict validation**: Only standard v1.0.0 vocabulary accepted
- **Rule-agnostic**: Records conditions without defining outcomes
- **No dependencies**: Pure Elixir standard library only

## Related Specifications

- [Game Protocol](https://sashite.dev/game-protocol/) — Conceptual foundation
- [CGSN Specification](https://sashite.dev/specs/cgsn/1.0.0/) — Official specification
- [CGSN Examples](https://sashite.dev/specs/cgsn/1.0.0/examples/) — Usage examples

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
