User.create full_name: "Hoàng Hải - Framgia",
  email: "hai.hp.96@gmail.com",
  password: "123456",
  role: 1

10.times do |index|
  User.create full_name: FFaker::Name.name_with_prefix_suffix,
    email: "example-#{index+1}@railstutorial.org",
    gender: Random.rand(0..2),
    password: "123456"
end

100.times do |index|
  Post.create title: FFaker::Education.degree_short,
    content: FFaker::Education.degree,
    user_id: Random.rand(1..10)
end

1000.times do |index|
  Comment.create content: FFaker::Lorem.phrase,
    post_id: Random.rand(1..100),
    user_id: Random.rand(1..10)
end

100.times do |index|
  Tag.create name: FFaker::CheesyLingo.title
end

100.times do |index|
  PostTag.create post_id: Random.rand(1..100),
    tag_id: Random.rand(1..100)
end

100.times do |index|
  Relationship.create follower_id: Random.rand(1..10),
    followed_id: Random.rand(1..10)
end
