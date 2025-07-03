module SEOHelper
  def build_meta_title(title)
    title.length < 30 ? "#{title} | Where Should We Go" : title
  end
end
