LANGUAGES_ATTRIBUTES = [
  { name: "English", code: "en", city_names: City.pluck(:name) },
  { name: "German", code: "de", city_names: [ "Munich", "Berlin", "Paderborn" ] },
  { name: "Spanish", code: "es", city_names: [ "Barcelona" ] },
  { name: "Catalan", code: "ca", city_names: [ "Barcelona" ] }
]

LANGUAGES_ATTRIBUTES.each do |language_attributes|
  language = Language.find_or_initialize_by(code: language_attributes[:code])
  if language.new_record?
    language.name = language_attributes[:name]

    language_attributes[:city_names].each do |city_name|
      city = City.find_by(name: city_name)
      city.languages << language
    end

    language.save!
  end
end
