# frozen_string_literal: true

describe "/" do
  it "renders" do
    visit "/"
    expect(page.status_code).to eq 200
    expect(page.body).to match "Global Names Crossmap"
  end

  it "uploads file" do
    file = File.join(__dir__, "..", "files", "wellformed-semicolon.csv")
    file = File.expand_path(file)
    visit "/"
    attach_file("name_list_file", file)
    click_button("Upload")
    expect(page.status_code).to eq 200
  end
end
