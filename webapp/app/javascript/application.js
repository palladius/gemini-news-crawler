// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// copiato da https://stackoverflow.com/questions/74749172/how-to-use-custom-js-on-a-rails-7-view
import "custom/main"

// from my ricc audio feature: https://hamzawais54.medium.com/integrating-audio-recording-into-a-ruby-on-rails-app-using-recordrtc-and-stimulusjs-f713b1c77bd9
import "controllers/audio_recording"
