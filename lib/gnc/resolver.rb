# frozen_string_literal: true

module Gnc
  # Performs crossmapping job of supplied list with a data source from GN
  class Resolver
    include SuckerPunch::Job
    workers 4

    def perform(token)
      ActiveRecord::Base.connection_pool.with_connection do
        begin
          resolve(token)
          logger.info "Success crossmapping with #{token}"
        rescue GnCrossmapError => e
          logger.error e.message
        end
      end
    end

    private

    def resolve(token)
      cmap = Crossmap.find_by_token(token)
      GnCrossmap.run(cmap.input,
                     cmap.output, cmap.data_source_id, true) do |stats|
        cmap.update(stats: stats)
      end
    end
  end
end
