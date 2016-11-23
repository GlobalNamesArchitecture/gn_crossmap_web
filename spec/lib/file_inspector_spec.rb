# frozen_string_literal: true

describe Gnc::FileInspector do
  let(:file) { open(File.join(__dir__, "..", "files", "taxonid_as_id.csv")) }

  describe ".inspect" do
    it "inspects a file" do
      res = subject.inspect(file)
      expect(res).to eq(is_csv: true, col_sep: ",")
    end

    context "not cvs files" do
      it "returns non-csv result" do
        %w(file.html file.pdf file.xlsx).each do |f|
          file = open(File.join(__dir__, "..", "files", f))
          res = subject.inspect(file)
          expect(res).to eq(is_csv: false, col_sep: "")
        end
      end
    end
  end
end
