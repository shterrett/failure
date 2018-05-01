# Failure is always an option

This library implements ruby-ified `Maybe` and `Either` types. Both capture
`nil` and `Exception` and return an object that implements the functor and monad
interfaces.

## Usage

### Maybe

`Maybe.new` takes a block and returns `Just <value>` on success and `Nothing` if
the block either returns `nil` or raises an exception.

```ruby
Maybe.new do
  [1, 2, 3].first
end

#=> Just 1

Maybe.new do
  [].first
end

#=> Nothing
```

`#map` is implemented on `Just` and `Nothing`, and is the functor `fmap`:

```haskell
map :: Maybe a -> (a -> b) -> Maybe b
```

```ruby
Maybe.new do
  [1, 2, 3].first
end.map do |i|
  i * 100
end

#=> Just 100

Maybe.new do
  [].first
end.map do |i|
  i * 100
end

#=> Nothing
```

`#flat_map` is implemented on `Just` and `Nothing`, and is the monad `bind`:

```haskell
flat_map :: Maybe a -> (a -> Maybe b) -> Maybe b
```

```ruby
Maybe.new do
  [[1], [2], [3]].first
end.flat_map do |i|
  Maybe.new { i.first }
end

#=> Just 1

Maybe.new do
  [1, 2, 3].first
end.flat_map do |i|
  Maybe.new { i.first } # raises NoMethodError
end

#=> Nothing
```

`Maybe.match` takes the maybe, a proc for the `Just` and a proc of no arguments
for the `Nothing` and returns the value of the associated variant. Because there
is no value for `Nothing`, a default value may be provided instead of a proc.


```haskell
match :: Maybe a -> (a -> b) -> b -> b
```

```ruby
just = Maybe.new do
  [1, 2, 3].first
end

nothing = Maybe.new do
  [].first
end

Maybe.match(just,
  just: ->(i) { i + 1 },
  nothing: 0
)

#=> 2

Maybe.match(nothing,
  just: ->(i) { i + 1 },
  nothing: 0
)

#=> 0
```

### Either

`Either` is similar to `Maybe` except that it preserves an error message from a
captured exception, or (trivially) the `nil` returned from a failed function.

`Either.new` takes a block and returns `Right <value>` if the block "succeeds",
and `Left <err | nil>` if the block raises or returns `nil`.

```ruby
Either.new do
  [1, 2, 3].first
end

#=> Right 1

Either.new do
  1.first
end

#=> Left NoMethodError
```

`#map` is implemented on `Right` and `Left` and is the functor `fmap`

```haskell
map :: Either a b -> (b -> c) -> Either a c
```

```ruby
Either.new do
  [1, 2, 3].first
end.map do |i|
  i * 100
end

#=> Right 100

Either.new do
  1.first
end.map do |i|
  i * 100
end

#=> Left NoMethodError
```

`#flat_map` is implemented on `Right` and `Left` and is the monad `bind`

```haskell
flat_map :: Either a b -> (b -> Either a c) -> Either a c
```

```ruby
Either.new do
  [[1], [2], [3]].first
end.flat_map do |i|
  Either.new { i.first }
end

#=> Right 1

Either.new do
  [1, 2, 3].first
end.flat_map do |i|
  Either.new { i.first }
end

#=> Left NoMethodError
```

`Either.match` takes an either, a proc for `Right` and a proc for `Left`,
evaluates the proc corresponding to the variant, and returns the result.

```haskell
match :: Either a b -> (a -> c) (b -> c) -> c
```

```ruby
right = Either.new do
  [1, 2, 3].first
end

left = Either.new do
  1.first
end

Either.match(right,
  right: ->(i) { i * 100 },
  left: ->(e) { e.message }
)

#=> 100

Either.match(left,
  right: ->(i) { i * 100 },
  left: ->(e) { e.message }
)

#=> "NoMethodError (undefined method `first' for 1:Integer)"
```

## Type Safety

There isn't any. Users are free to reach inside the classes using
`instance_variable_get` or `send`, and users can use `flat_map` with a block
that doesn't return an either to "unwrap" the value. And nothing constrains the
two procs in `.match` to return the same type. If we wanted type safety, we'd
use Haskell or Rust. But, just like everything else in ruby, this can be used to
make programming nicer.
