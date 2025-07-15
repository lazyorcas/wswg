module Events::SEO
  extend ActiveSupport::Concern

  def build_meta_title
    @meta_title = events_page_builder.build_meta_title
  end

  def build_meta_description
    @meta_description = events_page_builder.build_meta_description
  end

  def build_title
    @title = events_page_builder.build_title
  end

  def build_description
    @description = events_page_builder.build_description
  end

  def build_alternate_links_attributes
    @alternate_links_attributes = events_page_builder.build_alternate_links_attributes
  end
end
