describe Checklist do
  describe ".version" do
    it "returns current version" do
      expect(subject.version).to match(/^[\d]+\.[\d]+\.[\d]+$/)
    end
  end

  describe ".logger" do
    it "returns a logger" do
      expect(Checklist.logger).to be_kind_of Logger
    end
  end

  describe ".logger=" do
    it "creates a new logger" do
      id = Checklist.logger.object_id
      info = Checklist.logger.to_s
      Checklist.logger = Logger.new("/dev/null")
      expect(Checklist.logger.object_id).to_not eq id
      expect(Checklist.logger.to_s).to_not eq info
    end
  end

  describe ".env" do
    it "returns app's environment" do
      expect(subject.env).to eq :test
    end
  end

  describe ".conf" do
    it "returns app's configuration in OpenStruct" do
      expect(subject.conf).to be_kind_of OpenStruct
    end

    it "has configuration data" do
      expect(subject.conf).to respond_to :database
      expect(subject.conf).to respond_to :session_secret
    end
  end
end
