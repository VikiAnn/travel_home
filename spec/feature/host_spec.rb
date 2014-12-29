require 'rails_helper'
context 'authenticated host', type: :feature do
  before(:each) do
    host_data = {  name: "Viki",
                   email_address: "viki@example.com",
                   password: "password",
                   password_confirmation: "password",
                   admin: false,
                   host_slug: "cheeseburgers",
                   host: true }

    host = User.create!(host_data)
    visit root_path
    fill_in "email_address", with: host.email_address
    fill_in "password", with: host.password
    click_button "Login"
  end

  it 'can create property listings' do
    visit new_property_path
    fill_in "Title", with: "Burger Shack"
    fill_in "Description", with: "Juicy and yummy shack"
    fill_in "Daily Rate", with: 500
    fill_in "Occupancy", with: 7
    select "House", :from => "Category"
    # find("#property_category_ids_#{burgers.id}").set(true)
    fill_in "Address 1", with: "123 Main St."
    fill_in "City", with: "Crapsville"
    fill_in "State", with: "CO"
    fill_in "Zip code", with: 80203
    click_button "Create Property"

    expect(current_path).to eq(user_path(host))
    expect(Property.last.categories).to eq([house])
    expect(Property.last.occupancy).to eq(7)
    expect(Property.last.address.id).to eq(1)
    expect(page).to have_content("Burger Shack")
  end

    xit 'can modify existing properties’ name, description, price, and photo' do
    burgers = Category.create!(name: "Burgers")
    burger = Property.create!(title: "Best Burger", description: "Good burger", price: 9.0, categories: [burgers])
    visit edit_admin_property_path(burger)

    fill_in "property_title", with: "Better Burger"
    fill_in "property_description", with: "Really good burger"
    fill_in "property_price", with: 10.0

    click_button "Update Property"
    expect(current_path).to eq(admin_properties_path)

    expect(page).to have_content("Better Burger")
    expect(page).not_to have_content("Best Burger")

    expect(page).to have_content("Really good burger")
    expect(page).not_to have_content("Good burger")

    expect(page).to have_content(10.0)
    expect(page).not_to have_content(9.0)
  end

    xit 'can retire an property from being sold' do
    burgers = Category.create!(name: "Burgers")
    property = Property.create!(title: "Best Burger", description: "Good burger", price: 9.0, categories: [burgers])

    visit edit_admin_property_path(property)
    check("Retired")
    find_button("Update Property").click
    expect(property.reload.retired?).to eq(true)
    visit properties_path
    expect(page).to_not have_content(property.title)
  end
end
