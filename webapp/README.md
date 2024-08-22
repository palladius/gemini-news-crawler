# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: `3.2.2`.
* Rails version: `7.1.3.2`.
* Database: 🐘 PostgreS
* Services (job queues, cache servers, search engines, etc.)
    * Jobs: `delayed_job_active_record` (I'm too lazy to spin up a Mongo)

Deployment:

* 📦🚢 dockerized in.. `Dockerfile` and launched through `entrypoint-8080.sh`
* 🧱 Cloud Build (auto): https://console.cloud.google.com/cloud-build/builds?project=palladius-genai
* 🏃 Launched on Cloud Run (both in `europe-west1`):
    * DEV: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/
    * PROD: https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/
* 🔏 Runs as compute SvcAcct: `272932496670-compute@developer.gserviceaccount.com`. Needs:
    * `Storage Admin`
    * `Vertex AI administrator`
* 🔋🐘 Postgres:
    * PROD: `pg-prod` in `europe-west6`
    * DEV:  `pg-dev` in `europe-north1`


## Recording audio

Docs:

* https://developer.mozilla.org/en-US/docs/Web/API/MediaRecorder
* add RTC: https://hamzawais54.medium.com/integrating-audio-recording-into-a-ruby-on-rails-app-using-recordrtc-and-stimulusjs-f713b1c77bd9
* https://hamzawais54.medium.com/integrating-audio-recording-into-a-ruby-on-rails-app-using-recordrtc-and-stimulusjs-f713b1c77bd9

Ideas:

* https://github.com/mouraleonardo/voice-recording-react-app
