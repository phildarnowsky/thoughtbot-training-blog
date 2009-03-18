Factory.define :post do |each|
  each.title 'Post title'
  each.body  'Hi mom!'
end

Factory.define :published_post, :parent => :post do |each|
  each.published true
end

Factory.define :unpublished_post, :parent => :post do |each|
  each.published false
end

Factory.define :comment do |each|
  each.title 'C title'
  each.body 'C body'
end
