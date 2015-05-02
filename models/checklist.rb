# Checklist keeps information about uploaded checklists
class Checklist < ActiveRecord::Base
  def transpose(rows_num = 3)
    file = File.join(__dir__, "..", "uploads", token)
    csv = CSV.open(file, "r:utf-8", col_sep: ";")
    rows = []
    csv.each_with_index do |row, i|
      break if i == rows_num
      rows << row
    end
    rows.transpose
  end
end
