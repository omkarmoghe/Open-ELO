# Open ELO

## Models

### Scalar

A `Scalar` is the simplest object that can be evaluated. It holds a single `value`. When used in an `Expression`, this `value` must respond to the symbol (i.e. support the method) defined by the `Expression#operator`.

```ruby
Scalar.new(1)
```

### Variable

A `Variable` represents a named value stored in the `Environment`. Unlike `Scalars`, `Variables` have no value until they are evaluated by an `Environment`. Evaluating a `Variable` that isn't present in the `Environment` will result in a `MissingVariableError`.

```ruby
Variable.new("variable_a")
```

### Expression

An expression represents 2 or more `operands` that are reduced using a defined `operator`. The `operands` of an `Expression` can be `Scalars`, `Variables`, or other `Expressions`.

And `Expression` can store its result back into the `Environment` by defining an `output`.

```ruby
# addition
Expression.new(:+, Scalar.new(1), Scalar.new(2))

# multiplication
Expression.new(:*, Variable.new("variable_a"), Scalar.new(2))

# storing output
Expression.new(:+, Scalar.new(1), Scalar.new(2), output: "one_plus_two")
```

### Environment

The `Environment` holds state in the form of a `variables` hash and can evaluate `Expressions`, `Scalars`, and `Variables` within a context. The environment handles updates to the state as `Expressions` run.

```ruby
environment = Environment.new(
  "variable_a" => 1,
  "variable_b" => 2,
)

environment.evaluate(Variable.new("variable_a"))
#=> 1

environment.evaluate(
  Expression.new(
    :+,
    Variable.new("variable_a"),
    Variable.new("variable_b"),
    output: "variable_c" # defines where to store the result value
  )
)
#=> 3

environment.variables
#=> { "variable_a" => 1, "variable_b" => 2, "variable_c" => 3 }
```

When evaluating multiple objects at a time, the value of the _last_ object will be returned.

```ruby
environment = Environment.new
environment.evaluate(
  Scalar.new(1),
  Expression.new(:+, Scalar.new(1), Scalar.new(2))
)
#=> 3
```

### Serialization

All models support serialization via:
- `as_json`: builds a serializable hash representation of the object
- `to_json`: builds a JSON string representing the object

## Building

1. Make sure you have Ruby installed, see `.ruby-version` for the version.
1. Install Bundler: `gem install bundler`
1. Use bundler to install dependencies: `bundle install`

## Testing

Spec files are located in `/test`. Run all tests using `bundle exec rake test`.
