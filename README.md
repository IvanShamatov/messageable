Messageable
===========

AMQP Wrapper for ActiveRecord

```ruby
class Event < ActiveRecord::Base
  include Messageable
  publish_after :create, queue: 'events'
end
```

After each Event.create Bunny will send ```self.to_json``` to queue 'events' using direct exchange.
