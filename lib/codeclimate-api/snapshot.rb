module Codeclimate
  module Api
    class Snapshot

      attr_reader :id, :repository_id, :commit_sha, :committed_at,
        :finished_at, :gpa, :covered_percent

      # Internal: Build a new instance of Codeclimate::Api::Snapshot
      #
      # attrs - the attributes to initialize the snapshot.
      #
      # Returns an instance of Codeclimate::Api::Snapshot.
      def initialize(attrs)
        @id = attrs[:id]
        @repository_id = attrs[:repo_id]
        @commit_sha = attrs[:commit_sha]
        @committed_at = Time.at(attrs[:committed_at]).to_datetime
        @finished_at = Time.at(attrs[:finished_at]).to_datetime
        @gpa = attrs[:gpa]
        @covered_percent = attrs[:covered_percent]
      end

      # Public: Whether the GPA has improved between repository snapshots.
      #
      # previous_snapshot - a previous snapshot to be compared.
      #
      # Returns a boolean if there has been an improvement.
      def improvement?(previous_snapshot)
        if previous_snapshot.nil?
          false
        else
          self.gpa > previous_snapshot.gpa
        end
      end

      # Public: Whether the GPA has declined between repository snapshots.
      #
      # previous_snapshot - a previous snapshot to be compared.
      #
      # Returns a boolean if there has been a decline.
      def decline?(previous_snapshot)
        if previous_snapshot.nil?
          false
        else
          self.gpa < previous_snapshot.gpa
        end
      end

      # Public: The difference in GPA between repository snapshots.
      #
      # previous_snapshot - a previous snapshot to be compared.
      #
      # Returns the difference.
      def difference(previous_snapshot)
        if previous_snapshot.nil?
          0.0
        else
          (self.gpa - previous_snapshot.gpa)
        end
      end
    end
  end
end