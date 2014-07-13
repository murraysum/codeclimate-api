module Codeclimate
  module Api
    class Snapshot

      attr_reader :id, :repository_id, :commit_sha, :committed_at,
        :finished_at, :gpa, :covered_percent

      def initialize(attrs)
        @id = attrs[:id]
        @repository_id = attrs[:repo_id]
        @commit_sha = attrs[:commit_sha]
        @committed_at = Time.at(attrs[:committed_at]).to_datetime
        @finished_at = Time.at(attrs[:finished_at]).to_datetime
        @gpa = attrs[:gpa]
        @covered_percent = attrs[:covered_percent]
      end
    end
  end
end