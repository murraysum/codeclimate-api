module Codeclimate
  module Api
    class Repository

      attr_reader :id, :account_id, :name, :url, :branch, :created_at,
        :last_snapshot, :previous_snapshot

      def initialize(attrs)
        @id = attrs[:id] 
        @account_id = attrs[:account_id] 
        @name = attrs[:name] 
        @url = attrs[:url]
        @branch = attrs[:branch]
        @created_at = Time.at(attrs[:created_at]).to_datetime
        @last_snapshot = Codeclimate::Api::Snapshot.new(attrs[:last_snapshot])
        if attrs[:previous_snapshot].nil?
          @previous_snapshot = nil
        else
          @previous_snapshot = Codeclimate::Api::Snapshot.new(attrs[:previous_snapshot])
        end
      end

      # Public: Whether the GPA has improved between repository snapshots
      def improvement?
        if previous_snapshot.nil?
          false
        else
          last_snapshot.gpa > previous_snapshot.gpa
        end
      end

      # Public: Whether the GPA has declined between repository snapshots
      def decline?
        if previous_snapshot.nil?
          false
        else
          last_snapshot.gpa < previous_snapshot.gpa
        end
      end

      def difference
        if previous_snapshot.nil?
          0.0
        else
          (last_snapshot.gpa - previous_snapshot.gpa).abs
        end
      end

      def self.find(id, branch = nil)
        path = branch.nil? ? "repos/#{id}" : "repos/#{id}/branches/#{branch}"
        Codeclimate::Api::Request.find(path, handler)
      end

      def self.refresh(id, branch = nil)
        path = branch.nil? ? "repos/#{id}/refresh" : "repos/#{id}/branches/#{branch}/refresh"
        Codeclimate::Api::Request.create(path)
      end

      private

      def self.handler
        Proc.new do |response|
          Codeclimate::Api::Repository.new(response)
        end
      end
    end
  end
end