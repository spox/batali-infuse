# Batali Infuse

Add an infusion of [Batali][1] to `chef-client`!

## Infusing Batali

This gem infuses Batali into `chef-client` to perform cookbook
resolution locally on the node and request the solution set
from the Chef Server.

## Origin of the infusion

There are some claims that the solver the Chef Server uses can
provide incorrect solutions. Though these are only claims, it
prompted the question:

> Can a client side solver be used to generate a solution?

As it turns out, it can!

## Usage

### Install

This is tested for Chef versions '~> 12.2'. If Chef is running via
the omnibus install the gem should be installed like so:

```
$ /opt/chef/emebedded/bin/gem install batali-infuse --no-document
```

If Chef is running via the system Ruby, just install the gem directly:

```
$ gem install batali-infuse --no-document
```

### Enable

The infusion is enabled via the `client.rb` file. Add the following
line to the top of the file:

```ruby
# /etc/chef/client.rb

require 'batali-infuse/sync'
```

### Least impact resolution

Batali includes a ["least impact"][2] feature when resolving cookbooks.
This feature can be enabled when resolving cookbooks on the local
node. The benefit of least impact updates is that nodes will not
automatically request the latest version of a cookbook available if
it has already been provisioned. Instead, it will use a "least impact"
approach when resolving cookbooks, and no update will occur if the
previous version is still available within the given constraints.

There are two ways the option can be enabled:

#### Node attribute

```ruby
node.set[:batali][:least_impact] = true
```

#### Chef configuration

```ruby
# /etc/chef/client.rb
...
batali_least_impact true
```
_NOTE: Enabling via the configuration file will override a disabled setting within the node attributes_

# Info

## Resolver

* Batali: https://github.com/hw-labs/batali
* Least impact updates: https://github.com/hw-labs/batali#least-impact-updates

## General

* Repository: https://github.com/hw-labs/batali-infuse
* IRC: Freenode @ #heavywater

[1]: https://github.com/hw-labs/batali "Light weight cookbook resolver"
[2]: https://github.com/hw-labs/batali#least-impact-updates "Batali: Least impact updates"