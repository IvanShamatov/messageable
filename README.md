Messageable
===========

AMQP Wrapper for ActiveRecord

```
class Event < ActiveRecord::Base
  include Messageable
  publish_after :create, queue: 'events'
end
```
