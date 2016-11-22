# frozen_string_literal: true

describe "/css" do
  it "renders" do
    visit "/css/app.css"
    expect(page.body).
      to match(/font-family: "Open sans", "Helvetica Neue"/)
  end
end
