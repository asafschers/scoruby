<a href="https://codeclimate.com/github/asafschers/scoruby"><img src="https://codeclimate.com/github/asafschers/random_forester/badges/gpa.svg" /></a>
[![Gem Version](https://badge.fury.io/rb/random_forester.svg)](https://badge.fury.io/rb/random_forester)
[![Build Status](https://travis-ci.org/asafschers/random_forester.svg?branch=master)](https://travis-ci.org/asafschers/random_forester)

# RandomForester

Reads Random Forest PMML files and creates Ruby Random Forest classifier model.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'random_forester'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install random_forester

## Usage

```ruby
random_forest = RandomForester.get_model 'sample.pmml'
features = {a: 1, b: true, c: "YES"}
random_forest.predict(features)
random_forest.decisions_count(features)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asafschers/random_forester. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

