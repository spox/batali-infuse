# Batali Wedge

Lets have some fun with `chef-client`!

## Wedge Batali

This gem wedges Batali into `chef-client` to perform cookbook
resolution locally on the node, and request the solution set
from the Chef Server.

## OMG WHY!?

There were old complaints about local solvers not generating
the same results as the solver on the server. So, what if we
just used the same solver, then you'd know you had the same
resolution. This lead to:

> I wonder if Batali could be wedged into the client

As it turns out, it can.

## Usage

This only support 12.2.x versions of Chef. The gem needs to be
installed into the omnibus like so:

```
$ /opt/chef/emebedded/bin/gem install batali-wedge --no-document
```

Then you can enable it via the `client.rb` file by adding this to
the top:

```ruby
# /etc/chef/client.rb

require 'batali-wedge/sync'
```

## What does this provide?

Cookbook resolution, just on the client, via Batali. There's no
least impact yet, but mostly because this was a first pass to
see _if_ it would work. The next release will likely include
that feature just to see what happens.

# Info

* Repository: https://github.com/hw-labs/batali-wedge
* IRC: Freenode @ #heavywater
