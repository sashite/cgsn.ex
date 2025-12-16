# Sashite.Cgsn

[![Hex.pm](https://img.shields.io/hexpm/v/sashite_cgsn.svg)](https://hex.pm/packages/sashite_cgsn)
[![Docs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/sashite_cgsn)
[![License](https://img.shields.io/hexpm/l/sashite_cgsn.svg)](https://github.com/sashite/cgsn.ex/blob/main/LICENSE.md)

> **CGSN** (Chess Game Status Notation) implementation for Elixir.

## What is CGSN?

CGSN (Chess Game Status Notation) provides a **rule-agnostic** taxonomy of observable game status values for abstract strategy board games. CGSN defines standardized identifiers for terminal conditions, player actions, and game progression states that can be recorded independently of competitive interpretation.

This library implements the [CGSN Specification v1.0.0](https://sashite.dev/specs/cgsn/1.0.0/).

## Installation

Add `sashite_cgsn` to your list of dependencies in `mix.exs`:
```elixir
def deps do
  [
    {:sashite_cgsn, "~> 1.0"}
  ]
end
```

## CGSN Format

CGSN status values are lowercase strings using underscore separators:

| Category | Examples |
|----------|----------|
| Position-inferable | `check`, `stale`, `checkmate`, `stalemate`, `nomove`, `bareking`, `mareking`, `insufficient` |
| Explicit-only | `resignation`, `illegalmove`, `timelimit`, `movelimit`, `repetition`, `agreement` |

## Usage

```elixir
# Validation
Sashite.Cgsn.valid?("checkmate")      # => true
Sashite.Cgsn.valid?("resignation")    # => true
Sashite.Cgsn.valid?("invalid")        # => false
Sashite.Cgsn.valid?("")               # => false

# Check inference capability
Sashite.Cgsn.inferable?("checkmate")       # => true
Sashite.Cgsn.inferable?("stalemate")       # => true
Sashite.Cgsn.inferable?("resignation")     # => false

Sashite.Cgsn.explicit_only?("resignation")  # => true
Sashite.Cgsn.explicit_only?("timelimit")    # => true
Sashite.Cgsn.explicit_only?("checkmate")    # => false

# Get all statuses
Sashite.Cgsn.statuses()
# => ["check", "stale", "checkmate", "stalemate", "nomove", ...]

# Get statuses by category
Sashite.Cgsn.inferable_statuses()
# => ["check", "stale", "checkmate", "stalemate", "nomove", "bareking", "mareking", "insufficient"]

Sashite.Cgsn.explicit_only_statuses()
# => ["resignation", "illegalmove", "timelimit", "movelimit", "repetition", "agreement"]
```

## Status Definitions

### Position-Inferable Statuses

Statuses that can be determined from position analysis when game rules are known:

| Status | Description |
|--------|-------------|
| `check` | A Terminal Piece of the active player's side can be captured by an opponent's Pseudo-Legal Move |
| `stale` | A Terminal Piece of the active player's side cannot be captured by any opponent's Pseudo-Legal Move |
| `checkmate` | Terminal Piece is in check, and all Pseudo-Legal Moves keep it in check |
| `stalemate` | Terminal Piece is stale, but all Pseudo-Legal Moves would put it in check |
| `nomove` | No Pseudo-Legal Moves available for the active player |
| `bareking` | One side has only Terminal Pieces remaining on the Board |
| `mareking` | All Terminal Pieces of at least one side have been removed from the Board |
| `insufficient` | Neither player has sufficient material to force a decisive result |

### Explicit-Only Statuses

Statuses requiring external information (history, clocks, declarations):

| Status | Description |
|--------|-------------|
| `resignation` | A player explicitly resigns |
| `illegalmove` | A move was played that violates game rules |
| `timelimit` | A player exceeds allotted time |
| `movelimit` | Match reaches a move-count limit |
| `repetition` | Same position occurs a specific number of times |
| `agreement` | Both players mutually agree to end the match |

## API Reference

### Validation
```elixir
Sashite.Cgsn.valid?(status)  # => boolean
```

### Categorization
```elixir
Sashite.Cgsn.inferable?(status)      # => boolean
Sashite.Cgsn.explicit_only?(status)  # => boolean
```

### Status Lists
```elixir
Sashite.Cgsn.statuses()              # => [String.t()]
Sashite.Cgsn.inferable_statuses()    # => [String.t()]
Sashite.Cgsn.explicit_only_statuses() # => [String.t()]
```

## Game Examples

### Chess (Western)
```elixir
# Scholar's Mate - inferable from position
Sashite.Cgsn.valid?("checkmate")       # => true
Sashite.Cgsn.inferable?("checkmate")   # => true

# Player resigns - must be explicitly recorded
Sashite.Cgsn.valid?("resignation")        # => true
Sashite.Cgsn.explicit_only?("resignation") # => true
```

### ShÅgi (Japanese)
```elixir
# Tsume (checkmate) - inferable from position
Sashite.Cgsn.valid?("checkmate")  # => true

# Sennichite (repetition) - requires move history
Sashite.Cgsn.valid?("repetition")        # => true
Sashite.Cgsn.explicit_only?("repetition") # => true
```

### Xiangqi (Chinese)
```elixir
# Jiangâ€"jun (check) - inferable from position
Sashite.Cgsn.valid?("check")       # => true
Sashite.Cgsn.inferable?("check")   # => true

# Bare king position
Sashite.Cgsn.valid?("bareking")    # => true
```

## Rule-Agnostic Design

CGSN records **observable facts** without defining competitive interpretation:

```elixir
# Same status, different interpretations
status = "stalemate"

# Western Chess: usually a draw
# Some variants: loss for stalemated player
# CGSN simply records: "Terminal Piece is stale; all Pseudo-Legal Moves would put it in check"

Sashite.Cgsn.valid?(status)      # => true
Sashite.Cgsn.inferable?(status)  # => true
```

## Properties

- **Rule-agnostic**: Independent of specific game mechanics or outcome interpretation
- **Observable-focused**: Records verifiable facts without competitive judgment
- **Inference-aware**: Distinguishes position-derivable from explicit-only statuses
- **String-based**: Simple string representation for broad compatibility
- **Functional**: Pure functions with no side effects
- **Immutable**: All data structures are immutable

## Related Specifications

- [CGSN Specification](https://sashite.dev/specs/cgsn/1.0.0/) — Official specification
- [CGSN Examples](https://sashite.dev/specs/cgsn/1.0.0/examples/) — Practical implementation guidance
- [PCN](https://sashite.dev/specs/pcn/) — Portable Chess Notation (uses CGSN for status field)
- [Game Protocol](https://sashite.dev/game-protocol/) — Conceptual foundation for abstract strategy games

## License

Available as open source under the [MIT License](https://opensource.org/licenses/MIT).

## About

Maintained by [Sashité](https://sashite.com/) — promoting chess variants and sharing the beauty of board game cultures.
