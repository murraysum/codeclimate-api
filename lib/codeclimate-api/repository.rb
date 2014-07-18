module Codeclimate
  module Api
    class Repository

      attr_reader :id, :account_id, :name, :url, :branch, :created_at,
        :last_snapshot, :previous_snapshot

      # Internal: Build a new instance of Codeclimate::Api::Repository
      #
      # attrs - the attributes to initialize the repository.
      #
      # Returns an instance of Codeclimate::Api::Repository.
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

      # Public: Find the given repository and branch information.
      #
      # id - the repository identifier.
      # branch - the branch (default: "master").
      #
      # Returns an instance of Codeclimate::Api::Repository.
      def self.find(id, branch = nil)
        path = branch.nil? ? "repos/#{id}" : "repos/#{id}/branches/#{branch}"
        Codeclimate::Api::Request.find(path, handler)
      end

      # Public: Refresh the given repository and branch.
      #
      # id - the repository identifier.
      # branch - the branch (default: "master").
      #
      # Returns whether the refresh was successful.
      def self.refresh(id, branch = nil)
        path = branch.nil? ? "repos/#{id}/refresh" : "repos/#{id}/branches/#{branch}/refresh"
        Codeclimate::Api::Request.create(path)
      end

      # Public: Refresh the current repository and branch.
      #
      # Returns whether the refresh was successful.
      def refresh
        Codeclimate::Api::Repository.refresh(id, branch)
      end

      # Public: Whether the GPA has improved between repository snapshots.
      #
      # Returns a boolean if there has been an improvement.
      def improvement?
        last_snapshot.improvement?(previous_snapshot)
      end

      # Public: Whether the GPA has declined between repository snapshots.
      #
      # Returns a boolean if there has been a decline.
      def decline?
        last_snapshot.decline?(previous_snapshot)
      end

      # Public: The absolute difference in GPA between repository snapshots.
      #
      # Returns the absolute difference.
      def difference
        last_snapshot.difference(previous_snapshot)
      end

      private

      # Private: The handler used to build a new repository instance.
      def self.handler
        Proc.new do |response|
          Codeclimate::Api::Repository.new(response)
        end
      end
    end
  end
end