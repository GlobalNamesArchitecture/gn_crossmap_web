describe Checklist do
  describe ".new" do
    it "creates a new checklist" do
      expect(subject.new).to be_kind_of Checklist
    end
  end
end
