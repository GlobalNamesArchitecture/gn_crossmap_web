# frozen_string_literal: true

module Gnc
  # Gnc::Uploader saves scinames list file on a local machine
  class Uploader
    def initialize(params)
      @params = OpenStruct.new(params)
      @list_file = nil
    end

    def save_list_file
      res = FileInspector.inspect(@params.tempfile)
      return unless res[:is_csv]
      token = Gnc.token
      open(Crossmap.input(token), "w") do |f|
        f.write(@params.tempfile.read)
      end
      save_db(res[:col_sep], token)
    end

    private

    def save_db(col_sep, token)
      Crossmap.create(filename: @params.filename,
                      input: Crossmap.input(token),
                      output: Crossmap.output(token, @params.filename),
                      col_sep: col_sep,
                      token: token)
    end
  end
end
