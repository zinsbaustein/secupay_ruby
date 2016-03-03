module SecupayRuby
  module DataObjects
    class User < Base
      API_FIELDS = {
        title: :title,
        company: :company,
        first_name: :firstname,
        last_name: :lastname,
        street: :street,
        house_number: :housenumber,
        zip: :zip,
        city: :city,
        phone_number: :telephone,
        date_of_birth: :dob_value,
        email: :email
      }
    end
  end
end