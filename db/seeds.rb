require 'faker'
Faker::Config.locale = 'en'

Comment.destroy_all
Post.destroy_all
User.destroy_all

puts "Creating 10 users..."
users = 10.times.map do |i|
  User.create!(
    email: "user#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
end
puts "Created #{users.size} users."

puts "Creating 50 posts with 1 to 4 comments each..."

posts = 50.times.map do
  title = Faker::Lorem.sentence(word_count: 6).chomp('.')
  body = 5.times.map { Faker::Lorem.paragraph }.join("\n\n")
  status = [:draft, :published].sample

  post = Post.create!(
    title: title,
    body: body,
    status: status,
    user: users.sample
  )

  rand(1..4).times do
    Comment.create!(
      body: Faker::Lorem.sentence(word_count: 10),
      user: users.sample,
      post: post
    )
  end

  post
end

puts "Created #{posts.size} posts and their comments."
