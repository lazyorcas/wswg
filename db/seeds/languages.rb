LANGUAGES_ATTRIBUTES = [
  [ "Catalan", "ca", [ "Barcelona" ] ],
  [ "Dutch", "nl", [ "Amsterdam" ] ],
  [ "English", "en", City.unscoped.pluck(:name) ],
  [ "French", "fr", [ "Montreal", "Paris" ] ],
  [ "German", "de", [ "Munich", "Berlin" ] ],
  [ "Spanish", "es", [ "Barcelona", "Madrid" ] ],
  [ "Italian", "it", [] ]
]

CITY_NAME_TO_ID = City.unscoped.pluck(:name, :id).to_h

LANGUAGES_ATTRIBUTES.each do |attrs_array|
  code = attrs_array[1]
  language = Language.find_or_initialize_by(code: code)

  if language.new_record?
    attrs = {
      name: attrs_array[0],
      code: code,
      city_languages_attributes: attrs_array[2].map do |city_name|
        { city_id: CITY_NAME_TO_ID[city_name] }
      end
    }

    language.attributes = attrs.slice(*Language.column_names)
    language.save!
  end
end
