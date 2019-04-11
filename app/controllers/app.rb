# frozen_string_literal: true

require 'roda'
require 'json'

require_relative '../models/task'

module Tasker
  # Roda class
  class Api < Roda
    plugin :environments
    plugin :halt

    configure do
      Task.setup
    end

    route do |routing| # rubocop:disable Metrics/BlockLength
      response['Content-Type'] = 'application/json'

      routing.root do
        { message: 'Tasker API running' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          routing.on 'task' do
            # GET api/v1/task/[id]
            routing.get String do |id|
              Task.find(id).to_json
            rescue StandardError
              routing.halt 404, { message: 'Task not found' }.to_json
            end

            # GET api/v1/task
            routing.get do
              output = { task_ids: Task.all }
              JSON.pretty_generate(output)
            end

            # POST api/v1/task
            routing.post do
              new_data = JSON.parse(routing.body.read)
              new_task = Task.new(new_data)
              if new_task.save
                response.status = 201
                { message: 'Task saved', id: new_task.id }.to_json
              else
                routing.halt 400, { message: 'Could not save task' }.to_json
              end
            rescue StandardError
              routing.halt 400, { message: 'Could not save task' }.to_json
            end
          end
        end
      end
    end
  end
end
