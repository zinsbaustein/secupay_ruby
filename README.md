# SecupayRuby

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/secupay_ruby`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'secupay_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secupay_ruby

## Usage

Configure the gem when you load your application like this:

```ruby
SecupayRuby.configure do |config|
  config.api_key = 'your secupay api key'
  config.host = SecupayRuby::Host::PRODUCTION # default, change to TEST for testing
end
```

Create a new payment like this:

```ruby
payment = SecupayRuby::Payment.new

payment.init(amount: 500, payment_type: SecupayRuby::Payment::Types::PREPAY) # calls the API to create a new payment

payment.hash # returns a hash serving as payment ID
payment.purpose # returns reference number to be used as reference in wire transfer
payment.payment_data # returns bank account information for this payment
```

Get status updates for a given payment
```ruby
payment = SecupayRuby::Payment.new(hash: 'payment_hash')
payment.load_status # calls API to get status information

payment.status # returns current status
...
```

Working with sub API keys: You can request new API keys through the API with you main key.
You will at least need some user information and a payout account.
Create objects containing this information and pass them to the method requesting the code.
Use the following code to get a new key:

```ruby
project_name = "Awesome new project"

user = SecupayRuby::DataObjects::User.new(title: "Mr.",
                                          company: "ACME GmbH & Co KG",
                                          first_name: "Peter",
                                          last_name: "Müller",
                                          street: "Sesamstraße",
                                          house_number: "Sesamstadt",
                                          zip: "12345",
                                          city: "Sesamstadt",
                                          phone_number: "0190123456",
                                          date_of_birth: "06.10.1980",
                                          email: "peter@example.com")

payout_account = SecupayRuby::DataObjects::PayoutAccount.new(iban: "DE123",
                                                             bic: "BIC456")

# request new key
subkey = SecupayRuby::ApiKey::SubKey.request_api_key(project_name: project_name,
                                                          user: user,
                                                          payout_account: payout_account)

# now you can create payment objects with the new key
payment = SecupayRuby::Payment.new api_key: subkey
```

For storing keys requested through the API in a database, we recommend you store it in encrypted form.
You have to store the ciphertext, iv and mac along with the project name.

```ruby
# for storage, do:
store\_in\_database(payment.ciphertext, payment.iv, payment.mac, payment.project_name)

...

# load info from database
ciphertext = load\_from\_database(ciphertext)
iv = load\_from\_database(iv)
mac = load\_from\_database(mac)
project_name = load\_from\_database(project_name)

# create subkey object from this information
subkey = SecupayRuby::ApiKey::SubKey.new(ciphertext: ciphertext,
                                         iv: iv,
                                         mac: mac,
                                         project_name: project_name)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/secupay_ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

