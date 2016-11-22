# frozen_string_literal: true

describe Gnc::Crossmapper do
  let(:data) do
    build(:crossmap, input: File.join(Gnc::App.root, "spec", "files",
                                      "wellformed-semicolon.csv"))
  end
  subject { Gnc::Crossmapper }

  describe ".new" do
    it "creates an instance" do
      expect(subject.new(data)).to be_kind_of Gnc::Crossmapper
    end
  end

  describe "#run" do
    it "performs namelist crossmapping" do
      cm = subject.new(data)
      cm.run
      csv = CSV.open(data.output, col_sep: "\t", headers: true)
      expect(csv.readline.to_hash.keys).
        to eq %w(TaxonId kingdom subkingdom phylum subphylum
                 superclass class subclass cohort superorder
                 order suborder infraorder superfamily family
                 subfamily tribe subtribe genus subgenus
                 section species subspecies variety form
                 ScientificNameAuthorship matchedType inputName
                 matchedName matchedCanonicalForm inputRank
                 matchedRank synonymStatus acceptedName
                 matchedEditDistance matchedScore matchTaxonID)
    end

    context "skip_original" do
      let(:data) do
        build(:crossmap, input: File.join(Gnc::App.root, "spec", "files",
                                          "wellformed-semicolon.csv"),
                         skip_original: true)
      end
      it "keeps only taxonID" do
        cm = subject.new(data)
        cm.run
        csv = CSV.open(data.output, col_sep: "\t", headers: true)
        expect(csv.readline.to_hash.keys).
          to eq %w(TaxonId matchedType inputName matchedName
                   matchedCanonicalForm inputRank matchedRank synonymStatus
                   acceptedName matchedEditDistance matchedScore matchTaxonID)
      end
    end
  end
end
