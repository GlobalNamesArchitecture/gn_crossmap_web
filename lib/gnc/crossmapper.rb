# frozen_string_literal: true

module Gnc
  # module that runs a crossmapper against included list
  class Crossmapper
    def initialize(crossmap_data)
      @data = crossmap_data
      @log = GnCrossmap.logger = Gnc::JobLogger.new(@data.token)
    end

    def run
      input = @data.input
      output = File.join(Gnc::App.public_folder, @data.output)
      ds_id = @data.data_source_id || 1 # Catalogue of Life ID
      no_original = @data.skip_original || false
      GnCrossmap.run(input, output, ds_id, no_original)
    end
  end
end
