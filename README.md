# Utf8Sanitizer

Removes invalid UTF8 characters & extra whitespace (carriage returns, new lines, tabs, spaces, etc.) from csv or strings. Also provides detailed report indicating row numbers containing non-UTF8 and extra whitespace, and before and after to compare changes.

Example:
```
"ABC Au\xC1tos, 123 E Main St, Anytown, TX, 78735, (888) 555-1234\n\r\n"
```

Returns:
```
"ABC Autos, 123 E Main St, Anytown, TX, 78735, (888) 555-1234"
```

Removed:
Non-UTF8: `\xC1`
Extra whitespace: `\n\r\n`


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

Options for UTF8 Sanitizing data:
1. CSV Parsing
2. Data Hash of strings

#### 1. CSV Parsing
To clean (UTF8 encode) CSV file containing non-UTF8 characters pass file_path as a hash like below.  Hash MUST be a SYMBOL and named `:file_path`
```
sanitized_data = Utf8Sanitizer.sanitize({file_path: "./path/to/your_csv.csv"})
```

#### 2. Hash of Strings
To clean (UTF8 encode) existing databases, web form submissions, or scraped data pass input data as a hash like below.  Hash MUST be a SYMBOL and named `:data`.  The value of `:data` should be an array of hashes like below.  

Below is just an example.  Your input hash keys inside the parent data array can be named anything (not limited to url, act_name, street, etc.), but must be hashes inside a parent array like the below structure and syntax.
```
array_of_hashes = [ { url: 'abc_autos_example.com',
                       act_name: 'ABC Aut\x92os',
                       street: '123 E Main St\r\n',
                       city: 'Austin',
                       state: 'TX',
                       zip: '78735',
                       phone: '(888) 555-1234\r\n' },
                     { url: 'xyz_trucks_example',
                       act_name: 'XYZ Aut\xC1os',
                       street: '456 W Main St\r\n',
                       city: 'Austin',
                       state: 'TX',
                       zip: '78735',
                       phone: '(800) 555-5678\r\n' },
                  }]

sanitized_data = Utf8Sanitizer.sanitize({data: array_of_hashes})
```

### Returned Sanitized Data Format
The returned data will contain a detailed report of the row or line numbers where UTF8 violations and extra white space were located.  The broad categories in the returned data will be in hash format with the following keys: `:stats`, `:file_path`, `:data` like below.

IMPORTANT: `:valid_data` is the clean, converted output from your CSV or strings input, directly accessible via `sanitized_data[:data][:valid_data]`.

Returned data also indicates if the input data was successfully encoded. In rare cases the data is beyond repair, and will be listed in the `:error` category.   

Each non-UTF8 row will be included in its original syntax like the example below and can be accessed directly via `sanitized_data[:data][:encoded_data]`.

The `:stats` are a breakdown of the results. `:defective_rows` and `:error_rows` will usually be the same number which refer to the rows which are beyond repair (very rare). Otherwise, the results will be `:valid_rows` if they were perfect or successfully sanitized, including `:encoded_rows` which refers to the number of rows that contained non-utf8 characters, and `:wchar_rows` which is short for 'whitespace character rows'.

`:data` is broken down into the following categories: `:valid_data`, `:encoded_data`, `:defective_data`, and `:error_data`.

Below is an example of the returned data (`:stats`, `:file_path`, `:data`)
**`sanitized_data` is a local variable, which you can name anything you like, but it must be assigned in the following syntax: `[:data][:valid_data]` and `[:data][:encoded_data]`, etc.**

```
{ stats:
  {
  total_rows: 2,
  header_row: 1,
  valid_rows: 2,
  error_rows: 0,
  defective_rows: 0,
  perfect_rows: 0,
  encoded_rows: 2,
  wchar_rows: 2
  },
  file_path: nil,
  data:
  {
    valid_data:
    [
      { row_id: '1',
        utf_status: 'encoded, wchar',
        url: 'abc_autos_example.com',
        act_name: 'ABC Autos Example',
        street: '123 E Main St',
        city: 'Austin',
        state: 'TX',
        zip: '78735',
        phone: '(888) 555-1234' },
      { row_id: '2',
        utf_status: 'encoded, wchar',
        url: 'xyz_trucks_example',
        act_name: 'XYZ Trucks Example',
        street: '456 W Main St',
        city: 'Austin',
        state: 'TX',
        zip: '78735',
        phone: '(800) 555-4321' }
    ],
    encoded_data:     [{ row_id: 1, text: "1,abc_autos_example.com,ABC Autos Example\x98_\xC0,123 E Main St,Austin,TX,78735,(888) 555-1234\r\n" },
                       { row_id: 2, text: "2,xyz_trucks_example,XYZ \xC1_\xCCTrucks Example,456 W Main St,Austin,TX,78735,(800) 555-4321\r\n" }],
    defective_data: [],
    error_data: []
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/4rlm/utf8_sanitizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Utf8Sanitizer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/4rlm/utf8_sanitizer/blob/master/CODE_OF_CONDUCT.md).
