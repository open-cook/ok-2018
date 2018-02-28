ThinkingSphinx::Index.define :recipe, :with => :active_record do
  indexes title
  indexes intro
  indexes content

  where "state = 'published'"

  has user_id, hub_id, published_at, created_at, updated_at
end
