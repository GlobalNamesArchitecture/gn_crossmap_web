def params(file_name, content_type = "text/comma-separated-values")
  file = File.join(__dir__, "..", "files", file_name)
  { "checklist_file" =>
    { filename: file_name, type: "text/comma-separated-values",
      name: "checklist_file", tempfile: open(file),
      head: "Content-Disposition: form-data; " \
      "name=\"checklist_file\"; " \
      "filename=\"wellformed-semicolon.csv\"\r\n" \
      "Content-Type: #{content_type}\r\nContent-Length: 34191\r\n" } }
end

def checklist_file(token)
  file = File.join(__dir__, "..", "files", "wellformed-semicolon.csv")
  dest = File.join(__dir__, "..", "..", "uploads", token)
  FileUtils.cp(file, dest)
end
