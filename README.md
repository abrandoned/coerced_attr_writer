# CoercedAttrWriter

Uses `to_java` coercion mechanism to convert ruby objects to native java objects when an attribute is assigned.

[Coercion Syntax](https://github.com/abrandoned/jruby_coercion)

The primary purpose here is reopening a java class that has been defined previously (such as JAX-WS classes) and adding
support for type coercion when being set to a Ruby Object.

## Installation

Add this line to your application's Gemfile:

    gem 'coerced_attr_writer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coerced_attr_writer

## Usage

```ruby
  class Java::ComSomeObjectNamespaceSequence::Request
    coerced_attr_writer :property
  end
```

When coerced_attr_writer is encountered this extension will reflect on the setters of the java class and find the
appropriate types that can be used to set `property` by looking for `setProperty(Type)`

When a ruby object is assigned to the property then the `to_java` type coercion registries are inspected for a matching
coercion before the property is set.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
