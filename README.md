# Capistrano::Gcp::Autoscaling

We were inspired by https://github.com/lserman/capistrano-elbas.
The gem helps deploy code to the all instances of the provided instance group.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-gcp-autoscaling'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-gcp-autoscaling
    
Add this line to Capfile

```ruby
require 'capistrano/gcp/autoscaling'
```

## Configuration

The gem uses a service account to get an access to GCP.
Read the documentation (https://cloud.google.com/iam/docs/creating-managing-service-accounts) if you don't know how to create it.

```ruby
set :gcp_project_id, nil
set :gcp_region, nil
set :gcp_scope, 'https://www.googleapis.com/auth/compute'
set :gcp_private_key, ENV['GCP_PRIVATE_KEY']
set :gcp_client_email, ENV['GCP_CLIENT_EMAIL']
```

## Usage

To provide an instance group, go to deploy/<stage>.rb and instead of server write the next line:

```ruby
instance_group_manager 'my-instance-group-manager1', user: 'apps', roles: %i(app web db)

instance_group_manager 'my-instance-group-manager2' do |_instance, index|
  index.zero? ? { user: 'apps', roles: %i(app web db) } : { user: 'apps', roles: %i(app web) }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a3.vorobyov/capistrano-gcp-autoscaling.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
