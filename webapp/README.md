# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Incidents

### 18apr24 raise ArgumentError.new("Unknown key: #{k.inspect}. Valid keys are: #{valid_keys.map(&:inspect).join(', ')}")

Changed the ARRAY suggested by AI to Vector ;)

  612  [2024-04-18 09:22:11 +0200] cd webapp/
  614  [2024-04-18 09:22:22 +0200] rails db:rollback STEP=3
  615  [2024-04-18 09:22:43 +0200] rails db:migrate
  620  [2024-04-18 09:23:25 +0200] RAILS_ENV=production rails db:rollback STEP=3
  621  [2024-04-18 09:23:31 +0200] RAILS_ENV=production rails db:migrate

Now the process of vectorization of thwe two fields is broken, but its a smaller problem to have.
