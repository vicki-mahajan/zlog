# Zlog - Blogging Platform

Zlog is a modern, full-featured blogging platform built with Ruby on Rails 7.1.5.1 and Ruby 3.1.6. It supports user authentication, post creation, comment threads, and filtered browsing. The platform uses PostgreSQL as the database and Devise for user management.

## Features

- User authentication using Devise
- Create, edit, and delete blog posts
- Add and manage comments under each post
- Slug-based URLs for SEO-friendly links
- Filter posts by title and content

## Tech Stack

- Ruby 3.1.6
- Rails 7.1.5.1
- PostgreSQL
- Devise (Authentication)
- Bootstrap 5 (Frontend styling)

## Setup Instructions

1. Clone the repository:

  git clone https://github.com/vicki-mahajan/zlog
  cd zlog

2. Install dependencies:

  bundle install
  yarn install

3. Setup the database:

  rails db:create
  rails db:migrate
  rails db:seed

4. Run the Rails server:
  
5. Open the app in your browser:
 
  You can log in using the following test credentials:
    Email: demo@example.com
    Password: password


## Design Decisions

- Devise was used for authentication to reduce boilerplate and ensure security best practices.
- Slug generation was added to posts for better SEO and user-friendly URLs.
- Comments are associated with users and posts to create threaded discussions.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
