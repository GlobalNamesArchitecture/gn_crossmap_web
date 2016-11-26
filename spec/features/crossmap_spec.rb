# frozen_string_literal: true

describe "/crossmaps/:token" do
  let(:crossmap) { create(:crossmap) }

  it "renders" do
    visit("/crossmaps/#{crossmap.token}")
    expect(page.status_code).to eq 200
  end
end
