# Sidekiq import + Redis message broker

Clone this repository:

```
git clone ssh://git@source.olisti.co:6222/olistik/sidekiq-redis.git
```

This funny URL is due to the fact that this Gitlab instance doesn't use the standard SSH port. 🤷

Install dependencies:

```
bundle install
```

Then generate a set of fake events with:

```
bundle exec ruby generate.rb
```

The directory `json` will be populated with `BATCHES_SIZE` json files, each of them containing a random set of events.

Now you can setup the way the system will behave when importing events and dispatching the messages to consumers.

Launch the Sidekiq server in a shell:

```
./bin/server
```

and, in other terminals, the two sample consumers:

```
bundle exec ruby consumers/blockchain.rb
```

```
bundle exec ruby consumers/reactions.rb
```

Now pump the events into the redis instance that is watched by the Sidekiq instance and see how the workers handles the batches and dispatch the events to the consumers by using Redis' PubSub.

Note that consumers simply listen to one or more _topics_ each of those optionally specified with wildcards.

This way when an event is published to the topic `"reaction-blockchain.io”` then both the consumers `"*reaction*"` and `"*blockchain*"` will receive that event.

When an event is published to a topic with no receiver, then that event will be silently ignored.

A consumer subscribing to a topic doesn't receive events published prior to its subscription.

Made with ❤️ by [@olistik](https://olisti.co).

Licensed under _agpl-3.0_ (see [LICENSE.md](LICENSE.md)).
