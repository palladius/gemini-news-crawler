# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: `3.2.2`.
* Rails version: `7.1.3.2`.
* Database: PostgreS
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)

Deployment:
* dockerized in.. `Dockerfile` and launched through `entrypoint-8080.sh`
* Cloud Build (auto): https://console.cloud.google.com/cloud-build/builds?project=palladius-genai
* Launched in:
* DEV: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/
* PROD: https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/

## Incidents

### 18apr24 raise ArgumentError.new("Unknown key: #{k.inspect}. Valid keys are: #{valid_keys.map(&:inspect).join(', ')}")

Changed the ARRAY suggested by AI to Vector ;)

  612  [2024-04-18 09:22:11 +0200] cd webapp/
  614  [2024-04-18 09:22:22 +0200] rails db:rollback STEP=3
  615  [2024-04-18 09:22:43 +0200] rails db:migrate
  620  [2024-04-18 09:23:25 +0200] RAILS_ENV=production rails db:rollback STEP=3
  621  [2024-04-18 09:23:31 +0200] RAILS_ENV=production rails db:migrate

Now the process of vectorization of thwe two fields is broken, but its a smaller problem to have.
