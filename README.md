Ruby API Library for Fat Zebra
==============================

[![Build Status](https://travis-ci.org/supporterhub/fat-zebra-api-client.svg?branch=master)](https://travis-ci.org/supporterhub/fat-zebra-api-client)

A Ruby client for the [Fat Zebra](https://www.fatzebra.com.au) Online Payment Gateway (for Australian Merchants)

This is an unofficial fork of the Fat Zebra API client. This version has been patched to allow multiple accounts to be used simultaneously.

Version 3.1.0.x of this gem aims to be a drop-in replacement for version 3.1.0 of the official gem.

It aims to maintain parity with the [official Fat Zebra API client](https://github.com/fatzebra/Ruby-Library).

Dependencies
------------

 * Ruby (tested on 2.3, 2.4, 2.5, 2.6)
 * Rest Client

Installing
----------

    gem install fat_zebra_multi

Or in a Rails App (or similar, with Bundler), in your Gemfile:

    gem "fat_zebra_multi"

Usage
-----

With one account:
```ruby
require 'fat_zebra_multi'

# Configuration only needs to be done once, usually in your rails initializers
FatZebra.configure do |config|
  config.username = 'TEST'
  config.token    = 'TEST'
end

purchase = FatZebra::Purchase.create(
  amount:      10000,
  card_holder: 'Bill Simpson',
  card_number: '5123456789012346',
  card_expiry: '05/2023',
  cvv:         '123',
  reference:   'ORDER-23',
  customer_ip: '203.99.87.4'
)

if purchase.successful?
  puts "Transaction ID: #{purchase.id}"
else
  abort "Error in transaction: #{purchase.errors}"
end
```

With multiple accounts:
```ruby
require 'fat_zebra_multi'

account_1 = FatZebra::Config.new(
  username:  'USERNAME_1',
  token:     'API_TOKEN_1',
)

account_2 = FatZebra::Config.new(
  username:  'USERNAME_2',
  token:     'API_TOKEN_2',
)

purchase = FatZebra::Purchase.create({
  amount:      10000,
  card_holder: 'Bill Simpson',
  card_number: '5123456789012346',
  card_expiry: '05/2023',
  cvv:         '123',
  reference:   'ORDER-23',
  customer_ip: '203.99.87.4'
}, {
  account: account_1
})

if purchase.successful?
  puts "Transaction ID: #{purchase.id}"
else
  abort "Error in transaction: #{purchase.errors}"
end
```


Documentation
-------------

Full API reference can be found at http://docs.fatzebra.com.au

Support
-------
If you have any issue with the Fat Zebra Ruby Client please contact us at support@fatzebra.com.au and we will be more then happy to help out. Alternatively you may raise an issue in github.

Pull Requests
-------------
If you would like to contribute to the plugin please fork the project, make your changes within a feature branch and then submit a pull request. All pull requests will be reviewed as soon as possible and integrated into the main branch if deemed suitable.
