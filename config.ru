# frozen_string_literal: true

require './app/controllers/app.rb'
run Tasker::Api.freeze.app
