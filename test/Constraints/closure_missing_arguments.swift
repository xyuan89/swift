// RUN: %target-typecheck-verify-swift -swift-version 5
// RUN: %target-typecheck-verify-swift -swift-version 6

// https://github.com/swiftlang/swift/issues/92022
// Missing closure parameters must be diagnosed even when function matching
// occurs inside another expression's contextual type.
func missingClosureArguments(_ condition: Bool) {
  let _: (Int) -> Int = { 1 } // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}}
  let _: ((Int) -> Int, Int) = ({ 1 }, 0) // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}} {{34-34= _ in}}
  let _: (((Int) -> Int, Int), Int) = (({ 1 }, 0), 0) // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}}
  let _: ((Int, Int) -> Int, Int) = ({ 1 }, 0) // expected-error {{contextual type for closure argument list expects 2 arguments, which cannot be implicitly ignored}} {{39-39= _,_ in}}
  let _: ((Int, Int) -> Int, Int) = ({ x in x }, 0) // expected-error {{contextual closure type '(Int, Int) -> Int' expects 2 arguments, but 1 was used in closure body}}

  let _: (Int) -> Int = condition ? { 1 } : { _ in 2 } // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}}
  let _: (Int) -> Int = condition ? { _ in 1 } : { 2 } // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}} {{51-51= _ in}}

  let (_, _): ((Int) -> Int?, (Int) -> Int?) = condition ? (
    { 1 }, // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}}
    { _ in 2 }
  ) : (
    { _ in 1 },
    { _ in 2 }
  )

  let _: [(Int) -> Int] = [{ 1 }] // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}}
  let _: (((Int) -> Int)?, Int) = ({ 1 }, 0) // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}}

  let _: ((Int) -> Int, Int) = ({ _ in 1 }, 0)
  let _: (Int) -> Int = condition ? { _ in 1 } : { _ in 2 }
}

func takesClosureTuple(_: ((Int) -> Int, Int)) {}

func missingClosureArgumentsInCall() {
  takesClosureTuple(({ 1 }, 0)) // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}}
  takesClosureTuple(({ _ in 1 }, 0))
}

func missingClosureArgumentsInReturn() -> ((Int) -> Int, Int) {
  ({ 1 }, 0) // expected-error {{contextual type for closure argument list expects 1 argument, which cannot be implicitly ignored}}
}
