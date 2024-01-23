# Book Store Project 📚🛒

## Overview 🌐

This is a Ruby on Rails and VueJS-based web application for a Book Store. The project allows administrators to manage books, while users can browse and purchase books.

## Technology 🖥️
- Ruby On Rails
- VueJS

## Getting Started 🚀

To set up the project, follow these steps:

1. Configure the database in `config/database.yml`, using PostgreSQL for both development and production environments, and SQLite3 for testing purposes. You can refer to an example configuration model in `config/database.yml.example`.
    ```yaml
    development:
      adapter: postgresql
      database: your_database_name
      url: your_database_url
      ...
    
    test:
      adapter: sqlite3
      database: db/test.sqlite3
      ...
    ```
2. Install dependencies by running `bundle install` and `yarn install`.
3. Set up [Supabase Storage](https://supabase.com/docs/guides/storage) for storing images.
4. Run `rails db:migrate` to apply database migrations.
5. Start the Rails server with `rails server`.
6. Run the VueJS app with `yarn start`.

## Models 📊

The project includes the following models:

- Users
- Profiles
- Addresses
- Telephones
- Genres
- Authors
- Publishers
- Books
- BookImages
- Orders
- OrderDetails

Each model has specific relationships. Refer to the model files for detailed information.

## Testing 🧪

[RSpec](https://rspec.info/) is used for testing the project. Run tests using the `rspec` command.

## Authentication 🔐

Authentication is handled using JSON Web Tokens (JWT).

## User Types 👥

There are two types of users:

- **ADMIN**: Administrators who have access to book management functionalities.
- **CUSTOMER**: Regular customers who can browse and purchase books.

## Deployment 🚢

The project is deployed on both Vercel and Render.com. Follow these steps for deployment:

- **Frontend (Vercel):** Hosted on Vercel. Follow the [Vercel deployment process](https://vercel.com/docs/deployment).
- **Backend (Render.com):** Hosted on Render.com. Follow the [Render.com deployment process](https://render.com/docs/deploy-rails).

Ensure proper configuration for both frontend and backend for seamless integration.

## Contributors 🤝

- [Fábio Torres (Plantere)](https://github.com/Plantere/)

## License 📜

This project is licensed under the [MIT License]().