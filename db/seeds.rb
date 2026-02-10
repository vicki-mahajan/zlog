require 'faker'
require 'open-uri'

# Clean up
puts "Cleaning up database..."
Message.destroy_all
ConversationUser.destroy_all
Conversation.destroy_all
Comment.destroy_all
Post.destroy_all
User.destroy_all

# Create Users
puts "Creating Users..."
users = []
10.times do |i|
  users << User.create!(
    email: "user#{i+1}@example.com",
    password: 'password123',
    password_confirmation: 'password123'
  )
end

# Create Posts (Instagram Style)
puts "Creating Posts..."
users.each do |user|
  3.times do
    puts "  Creating post for #{user.email}..."
    post = Post.new(
      body: Faker::Lorem.sentence(word_count: 8), # Caption
      status: :published,
      user: user
    )

    # Attach a random image from Picsum
    # We use a random ID to get different images
    image_url = "https://picsum.photos/seed/#{SecureRandom.hex(4)}/800/800"
    downloaded_image = URI.open(image_url)
    post.image.attach(io: downloaded_image, filename: "image_#{SecureRandom.hex(4)}.jpg")
    
    post.save!

    # Add Comments
    rand(0..5).times do
      Comment.create!(
        user: users.sample,
        post: post,
        body: Faker::Lorem.sentence(word_count: 5)
      )
    end
  end
end

# Create Chats
puts "Creating Chats..."
5.times do
  sender = users.sample
  recipient = (users - [sender]).sample
  
  conversation = Conversation.create!
  ConversationUser.create!(conversation: conversation, user: sender)
  ConversationUser.create!(conversation: conversation, user: recipient)

  # Add Messages
  rand(5..15).times do
    Message.create!(
      conversation: conversation,
      user: [sender, recipient].sample,
      body: Faker::Lorem.sentence(word_count: 6)
    )
  end
end

puts "Seeding completed successfully!"
puts "Created #{User.count} Users"
puts "Created #{Post.count} Posts"
puts "Created #{Comment.count} Comments"
puts "Created #{Conversation.count} Conversations"
puts "Created #{Message.count} Messages"
