# Sashite.Cgsn

[![Hex.pm](https://img.shields.io/hexpm/v/sashite_cgsn.svg)](https://hex.pm/packages/sashite_cgsn)
[![Docs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/sashite_cgsn)
[![License](https://img.shields.io/hexpm/l/sashite_cgsn.svg)](https://github.com/sashite/cgsn.ex/blob/main/LICENSE)

> **CGSN** (Chess Game Status Notation) reference implementation for Elixir.

## What is CGSN?

CGSN (Chess Game Status Notation) defines a **finite, standardized list** of **rule-agnostic** status identifiers describing **observable aspects of a game state** for two-player, turn-based abstract strategy board games.

CGSN focuses on *what can be observed or verified*, not on *how a status impacts the result* (win/loss/draw), which remains Rule System– or competition-defined.

This library implements the **CGSN Specification v1.0.0**:
- https://sashite.dev/specs/cgsn/1.0.0/
- Examples: https://sashite.dev/specs/cgsn/1.0.0/examples/

## Installation

Add `sashite_cgsn` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sashite_cgsn, "~> 1.0"}
  ]
end
```

## Status identifiers

CGSN status values are **lowercase string identifiers** (e.g. `checkmate`, `repetition`).

CGSN v1.0.0 standard statuses are:

### Terminal Piece statuses (position-inferable)

These describe the condition of a **specific Terminal Piece** of the active player's side relative to opponent capture threats.
They are **position-inferable** given the current Position + Rule System.

| Status      | Description                                                                                                         |
| ----------- | ------------------------------------------------------------------------------------------------------------------- |
| `check`     | A specific Terminal Piece of the active player's side can be captured by an opponent's Pseudo-Legal Move            |
| `stale`     | A specific Terminal Piece of the active player's side cannot be captured by any opponent's Pseudo-Legal Move        |
| `checkmate` | That same Terminal Piece is in `check`, and every Pseudo-Legal Move by the active player still leaves it in `check` |
| `stalemate` | That same Terminal Piece is `stale`, but every Pseudo-Legal Move by the active player would put it in `check`       |

> Note: In CGSN’s model, `check`/`stale` are evaluated **per Terminal Piece** (some games may have multiple Terminal Pieces per side).

### Position statuses (position-inferable)

These describe global properties of the Position (not tied to a single piece).

| Status         | Description                                                                                                             |
| -------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `nomove`       | No Pseudo-Legal Moves exist for the active player                                                                       |
| `bareking`     | At least one side has **exactly one piece on the Board**, and that piece is a Terminal Piece (Hands are not considered) |
| `mareking`     | At least one side has **no Terminal Pieces on the Board**                                                               |
| `insufficient` | Under the Rule System’s insufficiency rules, neither side can force a decisive outcome with the available material      |

### External event statuses (explicit-only)

These cannot be derived from Position + Rule System alone. They require extra context (history, clocks, declarations, etc.) and must be explicitly recorded by the surrounding notation when they occur.

| Status        | Description                                                                                 |
| ------------- | ------------------------------------------------------------------------------------------- |
| `resignation` | A player explicitly resigned                                                                |
| `illegalmove` | A played move is recognized as not being a Legal Move under the Game Protocol + Rule System |
| `timelimit`   | A player exceeded the time control limit                                                    |
| `movelimit`   | The match reached a move-count limit defined by rules or competition regulations            |
| `repetition`  | A position repeated according to the Rule System’s repetition policy                        |
| `agreement`   | Both players mutually agreed to end the match                                               |

## Usage

```elixir
# Validation (CGSN v1.0.0 standard vocabulary)
Sashite.Cgsn.valid?("checkmate")      # => true
Sashite.Cgsn.valid?("resignation")    # => true
Sashite.Cgsn.valid?("invalid")        # => false
Sashite.Cgsn.valid?("")               # => false

# Classification
Sashite.Cgsn.inferable?("checkmate")        # => true
Sashite.Cgsn.inferable?("repetition")       # => false

Sashite.Cgsn.explicit_only?("repetition")   # => true
Sashite.Cgsn.explicit_only?("stalemate")    # => false

# Lists
Sashite.Cgsn.statuses()
# => ["check", "stale", "checkmate", "stalemate", "nomove", "bareking", "mareking", "insufficient",
#     "resignation", "illegalmove", "timelimit", "movelimit", "repetition", "agreement"]

Sashite.Cgsn.inferable_statuses()
# => ["check", "stale", "checkmate", "stalemate", "nomove", "bareking", "mareking", "insufficient"]

Sashite.Cgsn.explicit_only_statuses()
# => ["resignation", "illegalmove", "timelimit", "movelimit", "repetition", "agreement"]
```

## Rule-agnostic design

CGSN records **observable conditions** without defining outcomes.

Example: `stalemate` is commonly a draw in Western chess, but other Rule Systems may treat it differently. CGSN only records the underlying condition.

## Related Specifications

- [Game Protocol](https://sashite.dev/game-protocol/) — Conceptual foundation
- [CGSN Specification](https://sashite.dev/specs/cgsn/1.0.0/) — Official specification
- [CGSN Examples](https://sashite.dev/specs/cgsn/1.0.0/examples/) — Usage examples

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
