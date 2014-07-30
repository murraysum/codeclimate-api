FactoryGirl.define do
  factory :snapshot, :class => Codeclimate::Api::Snapshot do
    id "407c8d1d13d637023100016c"
    repo_id "4907075af3ea000dc6000740"
    commit_sha "72f1c6ae07cc465df70aa372dc972e835f355972"
    committed_at 1368165656
    finished_at 1368165666
    gpa 3.0
    covered_percent 46

    initialize_with do
      new(attributes)
    end
  end

  factory :lower_gpa_snapshot, :parent => :snapshot do
    gpa 2.0
  end

  factory :higher_gpa_snapshot, :parent => :snapshot do
    gpa 4.0
  end
end