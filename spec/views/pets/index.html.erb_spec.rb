require 'rails_helper'
require 'faker'

RSpec.describe "pets/index.html.erb", type: :view do

  context "displays all the pets" do
    genders = %w(macho fêmea)
    castrated = [true, false]
    breeds = YAML.load_file('config/breeds.yml')
    before(:each) do
      assign(:pets, [
       Pet.create( fullname: Faker::Pokemon.name, breed: breeds.sample,
              gender: genders.sample, castrated: castrated.sample,
              birth_date: Faker::Date.birthday(0, 25),
              last_visit: Faker::Date.backward(730), user: User.all.sample
            ),
        Pet.create( fullname: Faker::Pokemon.name, breed: breeds.sample,
              gender: genders.sample, castrated: castrated.sample,
              birth_date: Faker::Date.birthday(0, 25),
              last_visit: Faker::Date.backward(730), user: User.all.sample
            ),
      ])
    end
    it "displays both widgets" do
      render

      expect(rendered).to match /Boris/
      expect(rendered).to match /Rex/
    end
  end
end
