# BraDocumentValidation

This gem allows to validate Brazilian documents, CPF and CNPJ, with format and digit verification.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bra_document_validation'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bra_document_validation

## Usage

```rb
validates :document_number, 'bra_document_validation/cpf': true
validates :document_number, 'bra_document_validation/cnpj': true
```

# Format

By default, it expects a raw document number (only numbers).
However you can pass options if your number is formatted.

```rb
validates :document_number, 'bra_document_validation/cpf': { formatted: true }
validates :document_number, 'bra_document_validation/cnpj': { formatted: false }
```

# Messaging

When the document format does not match `invalid_format` message is added to the errors on field.
When the document verification digit is invalid `invalid_verification_digit`.
However you can add a custom message that substitute the above messages.

```rb
validates :document_number, 'bra_document_validation/cpf': { message: :invalid }
validates :document_number, 'bra_document_validation/cnpj': { message: 'A custom message' }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bra_document_validation.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
