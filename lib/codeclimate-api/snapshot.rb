module Codeclimate
  module Api
    class Snapshot

      attr_reader :id, :repository_id, :commit_sha, :committed_at,
        :finished_at, :gpa, :covered_percent

      def initialize(attrs)
        @id = attrs[:id]
        @repository_id = attrs[:repo_id]
        @commit_sha = attrs[:commit_sha]
        @committed_at = attrs[:committed_at]
        @finished_at = attrs[:finished_at]
        @gpa = attrs[:gpa]
        @covered_percent = attrs[:covered_percent]
      end
    end
  end
end