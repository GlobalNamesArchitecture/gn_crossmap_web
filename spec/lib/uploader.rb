describe Gnc::Uploader do
  let(:params) { params("wellformed-semicolon.csv") }
  subject { Gnc::Uploader.new(params) }
  describe ".new" do
    it { is_expected.to be_kind_of Gnc::Uploader }
  end
end
