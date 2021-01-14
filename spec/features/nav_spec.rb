require 'rails_helper'

RSpec.describe "Nav bar" do
  it "has links to basic navigation pages" do
    visit admin_path

    expect(page).to have_link("Admin Dashboard", href: admin_path)
    expect(page).to have_link("Admin Merchants Index", href: admin_merchants_path)
    expect(page).to have_link("Merchants Index", href: merchants_path)
  end
end