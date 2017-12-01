<a href="https://codeclimate.com/github/asafschers/scoruby"><img src="https://codeclimate.com/github/asafschers/scoruby/badges/gpa.svg" /></a>
[![Coverage Status](https://coveralls.io/repos/github/asafschers/scoruby/badge.svg?branch=master)](https://coveralls.io/github/asafschers/scoruby?branch=master)
[![Gem Version](https://badge.fury.io/rb/scoruby.svg)](https://badge.fury.io/rb/scoruby)
[![Build Status](https://travis-ci.org/asafschers/scoruby.svg?branch=master)](https://travis-ci.org/asafschers/scoruby)

# Scoruby

Ruby scoring API for Predictive Model Markup Language (PMML).

Currently supports Decision Tree, Random Forest Naive Bayes and Gradient Boosted Models.

Will be happy to implement new models by demand, or assist with any other issue.

Contact me here or at aschers@gmail.com.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scoruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scoruby

## Usage
### Random Forest

[Generate PMML - R](https://github.com/asafschers/scoruby/wiki/Random-Forest) 
#### Classify by PMML - Ruby

```ruby

random_forest = Scoruby.load_model 'titanic_rf.pmml'
features =  {
        Sex: 'male',
        Parch: 0,
        Age: 30,
        Fare: 9.6875,
        Pclass: 2,
        SibSp: 0,
        Embarked: 'Q'       
    }

random_forest.predict(features)

=> {:label=>"0", :score=>0.882}

random_forest.decisions_count(features)

=> {"0"=>441, "1"=>59}

```

### Gradient Boosted model

[Generate PMML - R](https://github.com/asafschers/scoruby/wiki/Gradient-Boosted-Model) 

#### Classify by PMML - Ruby

```ruby

gbm = Scoruby.load_model 'gbm.pmml'

features =  {
        Sex: 'male',
        Parch: 0,
        Age: 30,
        Fare: 9.6875,
        Pclass: 2,
        SibSp: 0,
        Embarked: 'Q'       
    }

gbm.score(features)

=> 0.3652639329522468

```

### Decision Tree

```ruby
decision_tree = Scoruby.load_model 'decision_tree.pmml'
features = { f1 : v1, ... } 
decision_tree.decide(features)

=> #<Decision:0x007fc232384180 @score="0", @score_distribution={"0"=>"0.999615579933873", "1"=>"0.000384420066126561"}>
```

### Naibve Bayes

```ruby
naive_bayes = Scoruby.load_model 'naive_bayes.pmml'
features = { f1: v1 , ... } 
naive_bayes.lvalues(features)
naive_bayes.score(features, 'l1')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asafschers/scoruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

