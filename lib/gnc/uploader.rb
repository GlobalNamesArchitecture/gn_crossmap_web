# frozen_string_literal: true

module Gnc
  # Gnc::Uploader saves scinames list file on a local machine
  class Uploader
    def initialize(params)
      @params = OpenStruct.new(params)
      @list_file = nil
    end

    def save_list_file
      return unless valid_csv?
      token = Gnc.token
      open(Crossmap.input(token), "w") do |f|
        f.write(@params.tempfile.read)
      end
      Crossmap.create(filename: @params.filename,
                      input: Crossmap.input(token),
                      output: Crossmap.output(token, @params.filename),
                      token: token)
    end

    def valid_csv?
      true
    end
  end
end
