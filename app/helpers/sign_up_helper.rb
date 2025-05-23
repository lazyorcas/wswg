module SignUpHelper
  def sign_up_page_title
    if sign_up_page_field_test.include?("free_word")
      "Create a free account"
    else
      "Create an account"
    end
  end

  def show_hero_image_in_sign_up_page?
    sign_up_page_field_test.include?("hero_image")
  end

  def sign_up_page_field_test
    @sign_up_page_field_test ||= field_test(:sign_up_page, exclude: signed_in?)
  end
end
