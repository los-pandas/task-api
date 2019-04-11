# frozen_string_literal: true

require 'json'
require 'base64'
require 'rbnacl'

module Tasker
  # Task class
  class Task
    STORE_DIR = 'app/db/store/'

    def initialize(new_task)
      @id = new_task['id'] || new_id
      @title = new_task['title']
      @description = new_task['description']
      @date_created = new_task['date_created']
      @assignee = new_task['assignee']
      @reporter = new_task['reporter']
      @status = new_task['status'] || 'new'
    end

    attr_reader :id, :title, :description, :date_created, :assignee, :reporter,
                :status

    def to_json(options = {}) # rubocop:disable Metrics/MethodLength
      JSON(
        {
          id: id,
          title: title,
          description: description,
          date_created: date_created,
          assignee: assignee,
          reporter: reporter,
          status: status
        },
        options
      )
    end

    # File store must be setup once when application runs
    def self.setup
      Dir.mkdir(STORE_DIR) unless Dir.exist? STORE_DIR
    end

    # Stores document in file store
    def save
      File.write(STORE_DIR + id + '.txt', to_json)
    end

    # Query method to find one document
    def self.find(find_id)
      document_file = File.read(STORE_DIR + find_id + '.txt')
      Task.new JSON.parse(document_file)
    end

    # Query method to retrieve index of all documents
    def self.all
      Dir.glob(STORE_DIR + '*.txt').map do |file|
        file.match(/#{Regexp.quote(STORE_DIR)}(.*)\.txt/)[1]
      end
    end

    private

    def new_id
      timestamp = Time.now.to_f.to_s
      Base64.urlsafe_encode64(RbNaCl::Hash.sha256(timestamp))[0..9]
    end
  end
end
