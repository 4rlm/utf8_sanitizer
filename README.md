# Utf8Sanitizer

Removes invalid UTF8 characters & extra whitespace (carriage returns, new lines, tabs, spaces, etc.) from csv or strings.

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

You have three options for UTF8 Sanitizing your data: CSV Parsing, Data Hash of strings, or run default seed data to test.

#### 1. CSV Parsing
This is a good option if you are having problems with a CSV containing non-UTF8 characters.  Pass your file_path as a hash like below.  Hash MUST be a SYMBOL and named `:file_path`.  If not, default seeds will be passed as the system detects empty user input and thinks user is trying to run built-in seed data for testing.
```
args = {file_path: "./path/to/your_csv.csv"}
sanitized_data = Utf8Sanitizer.sanitize(args)
```

#### 2. Hash of Strings
This is a good option if you are scraping data or cleaning up existing databases.  Pass your data as a hash like below.  Hash MUST be a SYMBOL and named `:data`.  The value of `:data` should be an array of hashes like below and can be any size from one to many tens of thousands.  The hashes inside the data array can be named anything from crm contact data like below, stats, recipes, or any custom hashes as long as they are in an array and resemble the syntax and structure like below.
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

sanitized_data = Utf8Sanitizer.sanitize(data: array_of_hashes)
```

#### 3. Run Seed Data to Test
If you want to run built-in seed data to first test, simply run as below without passing args.
```
sanitized_data = Utf8Sanitizer.sanitize
```

### Returned Sanitized Data Format
The returned data will be in hash format with the following keys: `:stats`, `:file_path`, `:data` like below.  

The `:stats` are a breakdown of the results. `:defective_rows` and `:error_rows` will usually be the same number which refer to the rows which are beyond repair (very rare). Otherwise, the results will be `:valid_rows` if they were perfect or successfully sanitized, including `:encoded_rows` which refers to the number of rows that contained non-utf8 characters, and `:wchar_rows` which is short for 'whitespace character rows'.

`:data` is broken down into the following categories: `:valid_data`, `:encoded_data`, `:defective_data`, and `:error_data`.

`:valid_data` is the most important data and you can access it with `sanitized_data[:data][:valid_data]`.  Each non-UTF8 row will be included in its original syntax like below and can be accessed directly via `sanitized_data[:data][:encoded_data]`.  

**You can change the name of `sanitized_data` to anything you like, but it must be followed with `[:data][:valid_data]` and `[:data][:encoded_data]`, etc.**

`:pollute_seeds` is only for running seed data.  It injects each row with non-UTF8 and extra whitespace for testing.  It can be ignored and will only run if your input is nil, which tells the system that you are intentionally trying to run seed data for testing.
```
{:stats=>
  {:total_rows=>2, :header_row=>1, :valid_rows=>2, :error_rows=>0, :defective_rows=>0, :perfect_rows=>0, :encoded_rows=>2, :wchar_rows=>2},
 :file_path=>nil,
 :data=>
  {:valid_data=>
    [{:row_id=>"1",
      :utf_status=>"encoded, wchar",
      :url=>"abc_autos_example.com",
      :act_name=>"ABC Autos Example",
      :street=>"123 E Main St",
      :city=>"Austin",
      :state=>"TX",
      :zip=>"78735",
      :phone=>"(888) 555-1234"},
     {:row_id=>"2",
      :utf_status=>"encoded, wchar",
      :url=>"xyz_trucks_example",
      :act_name=>"XYZ Trucks Example",
      :street=>"456 W Main St",
      :city=>"Austin",
      :state=>"TX",
      :zip=>"78735",
      :phone=>"(800) 555-4321"}],
   :encoded_data=>
    [{:row_id=>1, :text=>"1,abc_autos_example.com,ABC Autos Example\x98_\xC0,123 E Main St,Austin,TX,78735,(888) 555-1234\r\n"},
     {:row_id=>2, :text=>"2,xyz_trucks_example,XYZ \xC1_\xCCTrucks Example,456 W Main St,Austin,TX,78735,(800) 555-4321\r\n"}],
   :defective_data=>[],
   :error_data=>[]},
  :pollute_seeds=>true}
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
