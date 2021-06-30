require "rails_helper"

RSpec.describe Courses::GcseRequirementsForm do
  describe "validations" do
    it "is invalid if no value is selected for accept_pending_gcse" do
      form = described_class.new(accept_pending_gcse: nil)
      expect(form.valid?).to be_falsey
    end

    it "is invalid if no value is selected for accept_gcse_equivalency" do
      form = described_class.new(accept_gcse_equivalency: nil)
      expect(form.valid?).to be_falsey
    end

    it "is invalid if no value is selected for additional_gcse_equivalencies" do
      form = described_class.new(
        accept_gcse_equivalency: true, accept_english_gcse_equivalency: nil,
        accept_maths_gcse_equivalency: nil, accept_science_gcse_equivalency: nil,
        additional_gcse_equivalencies: nil
      )
      expect(form.valid?).to be_falsey
    end
  end

  describe "#save" do
    let(:course) { instance_double(Course) }

    it "returns false if invalid" do
      form = described_class.new(
        accept_pending_gcse: nil, accept_gcse_equivalency: nil, accept_english_gcse_equivalency: nil,
        accept_maths_gcse_equivalency: nil, accept_science_gcse_equivalency: nil,
        additional_gcse_equivalencies: nil
      )
      expect(form.save(course)).to eq false
    end
    context "all values marked as true and completed" do
      it "returns true if valid" do
        allow(course).to receive(:update).and_return(true)

        form = described_class.new(
          accept_pending_gcse: true, accept_gcse_equivalency: true, accept_english_gcse_equivalency: true,
          accept_maths_gcse_equivalency: true, accept_science_gcse_equivalency: true,
          additional_gcse_equivalencies: "Geography"
        )
        expect(form.save(course)).to eq true
      end
    end

    context "essential values marked as false" do
      it "returns true if valid" do
        allow(course).to receive(:update).and_return(true)

        form = described_class.new(
          accept_pending_gcse: false, accept_gcse_equivalency: false, accept_english_gcse_equivalency: nil,
          accept_maths_gcse_equivalency: nil, accept_science_gcse_equivalency: nil,
          additional_gcse_equivalencies: nil
        )
        expect(form.save(course)).to eq true
      end
    end
  end

  describe "#build_from_course" do
    it "builds a new GcseRequirementsForm and sets the attrs based on the course" do
      course = build(
        :course,
        accept_pending_gcse: true, accept_gcse_equivalency: true, accept_english_gcse_equivalency: true,
        accept_maths_gcse_equivalency: true, accept_science_gcse_equivalency: true,
        additional_gcse_equivalencies: "Geography"
      )
      form = described_class.build_from_course(course)

      expect(form.accept_pending_gcse).to eq true
      expect(form.accept_gcse_equivalency).to eq true
      expect(form.accept_english_gcse_equivalency).to eq true
      expect(form.accept_maths_gcse_equivalency).to eq true
      expect(form.accept_science_gcse_equivalency).to eq true
      expect(form.additional_gcse_equivalencies).to eq "Geography"
    end
  end
end
