module Gnc
  # Gnc::Uploader saves checklist file on a local machine
  class Uploader
    def initialize(params)
      @params = OpenStruct.new(params)
      @checklist = nil
    end

    def save_checklist
      return unless valid_csv?
      token = Gnc.token
      File.open(File.join(__dir__, "..", "..", "uploads", token), "w") do |f|
        f.write(@params.tempfile.read)
      end
      Checklist.create(filename: @params.filename, token: token)
    end

    def valid_csv?
      true
    end
  end
end
