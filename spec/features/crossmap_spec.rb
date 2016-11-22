# frozen_string_literal: true

describe "/crossmaps/:token" do
  let(:crossmap) { create(:crossmap) }

  it "renders" do
    visit("/crossmaps/#{crossmap.token}")
    expect(page.status_code).to eq 200
    expect(page.body).to match crossmap.token
  end

  it "has link to data sources" do
    visit("/crossmaps/#{crossmap.token}")
    click_link("Select Data Source")
    expect(page.status_code).to eq 200
    expect(page.body).to match "Data Sources"
  end
end
