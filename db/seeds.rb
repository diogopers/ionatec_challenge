require 'yaml'

User.destroy_all

genders = %w(macho fêmea)
castrated = [true, false]
breeds = YAML.load_file('config/breeds.yml')

80.times {
  User.create(fullname: Faker::Name.name, phone: Faker::PhoneNumber.cell_phone)
}

100.times {
  Pet.create( fullname: Faker::Pokemon.name, breed: breeds.sample,
              gender: genders.sample, castrated: castrated.sample,
              birth_date: Faker::Date.birthday(0, 25),
              last_visit: Faker::Date.backward(730), user: User.all.sample
            )
          }
