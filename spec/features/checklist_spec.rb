describe "/checklists/:token" do
  let(:checklist) { create(:checklist) }

  it "renders" do
    visit("/checklists/#{checklist.token}")
    expect(page.status_code).to eq 200
    expect(page.body).to match checklist.token
  end

  it "has link to data sources" do
    visit("/checklists/#{checklist.token}")
    click_link("Select Data Source")
    expect(page.status_code).to eq 200
    expect(page.body).to match "Data Sources"
  end
end
