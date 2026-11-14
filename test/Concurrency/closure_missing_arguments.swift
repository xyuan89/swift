// RUN: %target-typecheck-verify-swift -swift-version 5
// RUN: %target-typecheck-verify-swift -swift-version 6
// REQUIRES: concurrency

// Only the ordinary parameters are required when converting a
// nonisolated(nonsending) function to a type with an isolated parameter.
func missingCallerIsolatedClosureArguments() {
  let _: (isolated (any Actor)?, Int) async -> Int =
    { 1 } as nonisolated(nonsending) (Int) async -> Int // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}} {{6-6= _ in}}
  let _: (Int, isolated (any Actor)?) async -> Int =
    { 1 } as nonisolated(nonsending) (Int) async -> Int // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}} {{6-6= _ in}}
  let _: (isolated (any Actor)?, Int, Int) async -> Int =
    { 1 } as nonisolated(nonsending) (Int, Int) async -> Int // expected-error {{contextual type for closure argument list expects 2 arguments, which cannot be implicitly ignored}} {{6-6= _,_ in}}

  let _: (isolated (any Actor)?, Int) async -> Int =
    { _ in 1 } as nonisolated(nonsending) (Int) async -> Int
  let _: (Int, isolated (any Actor)?) async -> Int =
    { _ in 1 } as nonisolated(nonsending) (Int) async -> Int
  let _: (isolated (any Actor)?, Int, Int) async -> Int =
    { _,_ in 1 } as nonisolated(nonsending) (Int, Int) async -> Int
}
