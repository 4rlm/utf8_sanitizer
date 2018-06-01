# Utf8Sanitizer

Removes invalid UTF8 characters & extra whitespace (carriage returns, new lines, tabs, spaces, etc.) from csv or strings.
Example: ABC Au\\xC1tos,123 E Main St,Anytown,TX,75142,(888) 555-1234\\n\\r\\n
Returns: ABC Autos,123 E Main St,Anytown,TX,75142,(888) 555-1234
Non-UTF8: \\xC1
Extra whitespace: \\n\\r\\n


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'utf8_sanitizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install utf8_sanitizer

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/utf8_sanitizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Utf8Sanitizer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/utf8_sanitizer/blob/master/CODE_OF_CONDUCT.md).
