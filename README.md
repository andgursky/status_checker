# StatusChecker

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/status_checker`. To experiment with that code, run `bin/console` for an interactive prompt.

StatusChecker gem is allows you to check http status of any web site and get the alert message to your e-mail box if it's response code not 200.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'status_checker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install status_checker

## Usage

In console:

    $ bundle exec bin/console
    $ checker = StatusChecker::Check.new(["youremail@mail.com"], 60, ["https://site1.com", "http://site2.com"])

All arguments has default values, but if you want to change them, go ahead :)

    $ checker.start

This method runs loop with checking response codes process. You'll receive message to youremail@mail.com if status code of any site you provided (site1 or site2) will be different from 200.
If you want, you can stop the program:

    $ checker.stop

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/status_checker.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

