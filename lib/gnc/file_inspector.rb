# frozen_string_literal: true

module Gnc
  # Determines what kind of file was uploaded
  module FileInspector
    class << self
      def inspect(file)
        col_sep, fields = inspect_content(file)
        if col_sep != "" && fields > 1
          { is_csv: true, col_sep: col_sep }
        else
          { is_csv: false, col_sep: "" }
        end
      end

      private

      def inspect_content(file)
        if !(`file #{file.path}` =~ /text/).nil?
          csv_properties(file)
        else
          ["", 0]
        end
      rescue CSV::MalformedCSVError
        ["", 0]
      end

      def csv_properties(file)
        col_sep = separator(file)
        csv = CSV.open(file, col_sep: col_sep)
        fields_num = csv.first.size
        csv.close
        [col_sep, fields_num]
      end

      def separator(file)
        line = file.readline
        file.rewind
        [";", ",", "\t"].map { |s| [line.count(s), s] }.sort.last.last
      end
    end
  end
end
