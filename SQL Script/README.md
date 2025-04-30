# 🎬 IMDb-Like Application — Oracle Database Schema & Procedures

This document explains the database schema and stored procedures used in the application. The system enables users to search and review movies, while admins can manage users and movie content.

---

## 📦 TABLES

### `users`
| Column         | Type           | Description                           |
|----------------|----------------|---------------------------------------|
| `user_id`      | `NUMBER` (PK)  | Unique ID for each user               |
| `email`        | `VARCHAR2(255)`| User login email (unique)             |
| `password_hash`| `VARCHAR2(512)`| Hashed password (e.g., SHA-256)       |
| `full_name`    | `VARCHAR2(200)`| Display name                          |
| `role`         | `VARCHAR2(20)` | Either `'USER'` or `'ADMIN'`          |

### `movies`
| Column        | Type             | Description                            |
|---------------|------------------|----------------------------------------|
| `movie_id`    | `NUMBER` (PK)    | Unique ID for the movie                |
| `title`       | `VARCHAR2(500)`  | Movie/TV show title                    |
| `release_year`| `NUMBER(4)`      | Year of release                        |
| `description` | `CLOB`           | Detailed summary                       |
| `avg_rating`  | `NUMBER(3,2)`    | Average of all user ratings            |

### `genres`
| Column     | Type             | Description               |
|------------|------------------|---------------------------|
| `genre_id` | `NUMBER` (PK)    | Unique genre ID           |
| `name`     | `VARCHAR2(100)`  | Genre name (e.g., Drama)  |

### `movie_genres`
| Column     | Type         | Description                     |
|------------|--------------|---------------------------------|
| `movie_id` | `NUMBER`     | FK to `movies(movie_id)`        |
| `genre_id` | `NUMBER`     | FK to `genres(genre_id)`        |

### `actors`
| Column     | Type             | Description       |
|------------|------------------|-------------------|
| `actor_id` | `NUMBER` (PK)    | Unique actor ID   |
| `name`     | `VARCHAR2(200)`  | Actor’s name      |

### `movie_cast`
| Column         | Type          | Description                         |
|----------------|---------------|-------------------------------------|
| `movie_id`     | `NUMBER`      | FK to `movies(movie_id)`            |
| `actor_id`     | `NUMBER`      | FK to `actors(actor_id)`            |
| `character_name`| `VARCHAR2(200)`| Role played in that movie          |

### `ratings`
| Column        | Type           | Description                                      |
|---------------|----------------|--------------------------------------------------|
| `rating_id`   | `NUMBER` (PK)  | Unique rating ID                                 |
| `user_id`     | `NUMBER`       | FK to `users(user_id)`                           |
| `movie_id`    | `NUMBER`       | FK to `movies(movie_id)`                         |
| `rating_value`| `NUMBER(2)`    | Numeric rating from 1 to 10                      |
| `created_at`  | `TIMESTAMP`    | When rating was submitted                        |

### `reviews`
| Column        | Type           | Description                                        |
|---------------|----------------|----------------------------------------------------|
| `review_id`   | `NUMBER` (PK)  | Unique review ID                                   |
| `user_id`     | `NUMBER`       | FK to `users(user_id)`                             |
| `movie_id`    | `NUMBER`       | FK to `movies(movie_id)`                           |
| `review_text` | `CLOB`         | Textual user review                                |
| `created_at`  | `TIMESTAMP`    | When the review was created                        |
| `updated_at`  | `TIMESTAMP`    | Updated time (if edited)                           |

### `watchlists`
| Column       | Type           | Description                                    |
|--------------|----------------|------------------------------------------------|
| `watchlist_id`| `NUMBER` (PK) | Unique row ID                                  |
| `user_id`    | `NUMBER`       | FK to `users(user_id)`                         |
| `movie_id`   | `NUMBER`       | FK to `movies(movie_id)`                       |
| `added_at`   | `TIMESTAMP`    | When the movie was added to the watchlist      |

---

## ⚙️ STORED PROCEDURES

### `CreateUser(email, password, full_name)`
Creates a new user account.
- **IN**: `email`, `password` (hashed), `full_name`
- **Role** defaults to `'USER'`
- **OUT**: *(none)*

### `SearchMovies(p_title, p_genre, p_year, cur_out)`
Searches movies by optional title, genre, and/or release year.
- **IN**:  
  - `p_title` – partial or full title (nullable)  
  - `p_genre` – genre name (nullable)  
  - `p_year` – release year (nullable)  
- **OUT**:  
  - `cur_out` – `REF CURSOR` of matching movie rows

### `GetMovieDetails(p_movie_id, cur_meta, cur_reviews)`
Returns metadata and reviews for a movie.
- **IN**: `p_movie_id`
- **OUT**:  
  - `cur_meta` – one row with title, year, genres, cast, rating, poster  
  - `cur_reviews` – list of user reviews with names and timestamps

### `SubmitRating(p_user_id, p_movie_id, p_value, out_msg)`
Submits or updates a rating for a movie.
- **IN**:  
  - `p_user_id` – who rated  
  - `p_movie_id` – movie being rated  
  - `p_value` – rating (must be 1–10)  
- **OUT**:  
  - `out_msg` – success or error message  
- Also updates `movies.avg_rating`

### `WriteReview(p_user_id, p_movie_id, p_text, out_msg)`
Adds a textual review for a movie.
- **IN**: `p_user_id`, `p_movie_id`, `p_text`
- **OUT**: `out_msg` – success or error

### `EditReview(p_review_id, p_user_id, p_text, out_msg)`
Edits an existing review (only by the original user).
- **IN**: `p_review_id`, `p_user_id`, `p_text`
- **OUT**: `out_msg`

### `DeleteReview(p_review_id, p_user_id, is_admin, out_msg)`
Deletes a review.  
- **IN**:  
  - `p_review_id`  
  - `p_user_id` – current user  
  - `is_admin` – boolean (TRUE if admin)  
- **OUT**: `out_msg`

### `AddToWatchlist(p_user_id, p_movie_id, out_msg)`
Adds a movie to the user's watchlist.
- **IN**: `p_user_id`, `p_movie_id`
- **OUT**: `out_msg` – success or "already exists"

### `RemoveFromWatchlist(p_user_id, p_movie_id, out_msg)`
Removes a movie from the user's watchlist.
- **IN**: `p_user_id`, `p_movie_id`
- **OUT**: `out_msg`

### `DeleteMovie(p_admin_id, p_movie_id, out_msg)`
Deletes a movie and all related data. Admin use only.
- **IN**: `p_admin_id`, `p_movie_id`
- **OUT**: `out_msg`

---

## 💡 Notes

- Passwords are **hashed in the C# application**, not in PL/SQL.
- Admins can use procedures like `DeleteMovie` or `DeleteReview` with elevated permissions.
- Search and detail procedures return `REF CURSOR` results, which can be read using `OracleDataReader` in C#.
