# Book Store Project 📚🛒

## Overview 🌐

This is a Ruby on Rails and VueJS-based web application for a Book Store. The project allows administrators to manage books, while users can browse and purchase books.

## Users For Testing in [BookStore](https://book-store-e3z2.onrender.com/) 🧪
- **Admin (John Doe):** *(You can access admin page from [here](https://book-store-e3z2.onrender.com/admin))*
  - **Email:** admin@example.com
  - **Password:** 123456

- **Client (Samantha Miller):**
  - **Email:** client@example.com
  - **Password:** 123456

(For Stripe transactions, you can use test cards available [here](https://docs.stripe.com/testing#cards))

## Technology 🖥️
- Ruby On Rails
- VueJS
- ViteRuby
- StripeJS

## Getting Started 🚀

To set up the project, follow these steps:

1. Enviroment Configuration: Copy the `.env.example` file and rename it to `.env`. Proceed to configure the Stripe integration by referring to the documentation at [Stripe Keys](https://stripe.com/docs/keys) and database configurations

2. Dependency Installation: Install project dependencies by executing the following commands:
    ```bash
    bundle install
    yarn install
    ```

3. Supabase Storage Setup: Set up [Supabase Storage](https://supabase.com/docs/guides/storage) to enable image storage functionalities within the application.

4. Database Migrations: Apply database migrations using the command:
    ```bash
    rails db:migrate
    ```

5. JavaScript Routes Generation: Generate JavaScript routes files for middleware using the following command:
    ```bash
    rails generate js_routes:middleware --pretend
    ```

6. Project Start: Initiate the project by running the following command, which starts the Rails server and Vue.js concurrently:
    ```bash
    foreman start -f Procfile.dev
    ```

7. Accessing the Project: The project is now accessible at [http://127.0.0.1:5100](http://127.0.0.1:5100). Explore and interact with the application locally.

## Models 📊

The project includes the following models:

- Users
- Profiles
- Addresses
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

The project is deployed on Render.com. Follow these steps for deployment:

- **Render.com:** Hosted on Render.com. Follow the [Render.com deployment process](https://render.com/docs/deploy-rails).

Ensure proper configuration for both frontend and backend for seamless integration.

## Contributors 🤝

- [Fábio Torres (Plantere)](https://github.com/Plantere/)

## License 📜

This project is licensed under the [MIT License]().
