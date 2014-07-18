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
      def improvement?
        if previous_snapshot.nil?
          false
        else
          last_snapshot.gpa > previous_snapshot.gpa
        end
      end

      # Public: Whether the GPA has declined between repository snapshots.
      def decline?
        if previous_snapshot.nil?
          false
        else
          last_snapshot.gpa < previous_snapshot.gpa
        end
      end

      # Public: The absolute difference in GPA between repository snapshots.
      def difference
        if previous_snapshot.nil?
          0.0
        else
          (last_snapshot.gpa - previous_snapshot.gpa).abs
        end
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