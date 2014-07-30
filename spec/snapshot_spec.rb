require 'spec_helper'

describe Codeclimate::Api::Snapshot do

  before :all do
    @snapshot = FactoryGirl.build(:snapshot)
  end

  describe "initializing a new snapshot" do
    it "has an id" do
      expect(@snapshot.id).to eql("407c8d1d13d637023100016c")
    end

    it "has a repository id" do
      expect(@snapshot.repository_id).to eql("4907075af3ea000dc6000740")
    end

    it "has a commit sha" do
      expect(@snapshot.commit_sha).to eql("72f1c6ae07cc465df70aa372dc972e835f355972")
    end

    it "has a commited at time" do
      expect(@snapshot.committed_at).to eql(Time.at(1368165656).to_datetime)
    end

    it "has a finished at time" do
      expect(@snapshot.finished_at).to eql(Time.at(1368165666).to_datetime)
    end

    it "has a gpa" do
      expect(@snapshot.gpa).to eql(3.0)
    end

    it "has a test coverage percentage" do
      expect(@snapshot.covered_percent).to eql(46)
    end
  end

  describe "#improvement?" do
    context "when the snapshot is nil" do
      it "is false" do
        expect(@snapshot.improvement?(nil)).to eql(false)
      end
    end

    context "when the previous snapshot gpa is lower" do
      it "is true" do
        @previous_snapshot = FactoryGirl.build(:lower_gpa_snapshot)
        expect(@snapshot.improvement?(@previous_snapshot)).to eql(true)
      end
    end

    context "when the previous snapshot gpa is higher" do
      it "is false" do
        @previous_snapshot = FactoryGirl.build(:higher_gpa_snapshot)
        expect(@snapshot.improvement?(@previous_snapshot)).to eql(false)
      end
    end

    context "when the previous snapshot gpa is equal" do
      it "is false" do
        @previous_snapshot = FactoryGirl.build(:snapshot)
        expect(@snapshot.improvement?(@previous_snapshot)).to eql(false)
      end
    end
  end

  describe "#decline?" do
    context "when the previous snapshot is nil" do
      it "is false" do
        expect(@snapshot.decline?(nil)).to eql(false)
      end
    end

    context "when the previous snapshot gpa is lower" do
      it "is false" do
        @previous_snapshot = FactoryGirl.build(:lower_gpa_snapshot)
        expect(@snapshot.decline?(@previous_snapshot)).to eql(false)
      end
    end

    context "when the previous snapshot gpa is higher" do
      it "is true" do
        @previous_snapshot = FactoryGirl.build(:higher_gpa_snapshot)
        expect(@snapshot.decline?(@previous_snapshot)).to eql(true)
      end
    end

    context "when the previous snapshot gpa is equal" do
      it "is false" do
        @previous_snapshot = FactoryGirl.build(:snapshot)
        expect(@snapshot.decline?(@previous_snapshot)).to eql(false)
      end
    end
  end

  describe "#difference" do
    context "when the previous snapshot is nil" do
      it "is zero" do
        expect(@snapshot.difference(nil)).to eql(0.0)
      end
    end

    context "when the previous snapshot gpa is lower" do
      it "is positive" do
        @previous_snapshot = FactoryGirl.build(:lower_gpa_snapshot)
        expect(@snapshot.difference(@previous_snapshot)).to eql(1.0)
      end
    end

    context "when the previous snapshot gpa is higher" do
      it "is negativee" do
        @previous_snapshot = FactoryGirl.build(:higher_gpa_snapshot)
        expect(@snapshot.difference(@previous_snapshot)).to eql(-1.0)
      end
    end

    context "when the previous snapshot gpa is equal" do
      it "is zero" do
        @previous_snapshot = FactoryGirl.build(:snapshot)
        expect(@snapshot.difference(@previous_snapshot)).to eql(0.0)
      end
    end
  end
end