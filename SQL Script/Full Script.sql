-- Oracle 11g-compatible schema

-- Sequences (since IDENTITY is not available in 11g)
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_movies START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_genres START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_actors START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ratings START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_reviews START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_watchlists START WITH 1 INCREMENT BY 1;

-- 1.1 Users
CREATE TABLE users (
  user_id        NUMBER PRIMARY KEY,
  email          VARCHAR2(255)   NOT NULL UNIQUE,
  password_hash  VARCHAR2(512)   NOT NULL,
  full_name      VARCHAR2(200),
  role           VARCHAR2(20)    NOT NULL
    CHECK (role IN ('USER','ADMIN'))
);

-- 1.2 Movies
CREATE TABLE movies (
  movie_id       NUMBER PRIMARY KEY,
  title          VARCHAR2(500)   NOT NULL,
  release_year   NUMBER(4)       NOT NULL,
  description    CLOB,
  poster_url     VARCHAR2(1000),
  avg_rating     NUMBER(3,2)     DEFAULT 0
);

-- 1.3 Genres & Movie–Genre Link
CREATE TABLE genres (
  genre_id       NUMBER PRIMARY KEY,
  name           VARCHAR2(100)   NOT NULL UNIQUE
);

CREATE TABLE movie_genres (
  movie_id       NUMBER NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
  genre_id       NUMBER NOT NULL REFERENCES genres(genre_id) ON DELETE CASCADE,
  PRIMARY KEY (movie_id, genre_id)
);

-- 1.4 Actors & Movie–Cast Link
CREATE TABLE actors (
  actor_id       NUMBER PRIMARY KEY,
  name           VARCHAR2(200)   NOT NULL
);

CREATE TABLE movie_cast (
  movie_id       NUMBER NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
  actor_id       NUMBER NOT NULL REFERENCES actors(actor_id) ON DELETE CASCADE,
  character_name VARCHAR2(200),
  PRIMARY KEY (movie_id, actor_id)
);

-- 1.5 Ratings
CREATE TABLE ratings (
  rating_id      NUMBER PRIMARY KEY,
  user_id        NUMBER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  movie_id       NUMBER NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
  rating_value   NUMBER(2)       NOT NULL CHECK (rating_value BETWEEN 1 AND 10),
  created_at     TIMESTAMP       DEFAULT SYSTIMESTAMP,
  UNIQUE (user_id, movie_id)
);

-- 1.6 Reviews
CREATE TABLE reviews (
  review_id      NUMBER PRIMARY KEY,
  user_id        NUMBER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  movie_id       NUMBER NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
  review_text    CLOB            NOT NULL,
  created_at     TIMESTAMP       DEFAULT SYSTIMESTAMP,
  updated_at     TIMESTAMP
);

-- 1.7 Watchlists
CREATE TABLE watchlists (
  watchlist_id   NUMBER PRIMARY KEY,
  user_id        NUMBER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  movie_id       NUMBER NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
  added_at       TIMESTAMP       DEFAULT SYSTIMESTAMP,
  UNIQUE (user_id, movie_id)
);

-- 2.1 CreateUser
CREATE OR REPLACE PROCEDURE CreateUser(
  p_email      IN VARCHAR2,
  p_password   IN VARCHAR2,
  p_full_name  IN VARCHAR2
) AS
BEGIN
  INSERT INTO users(user_id, email, password_hash, full_name, role)
    VALUES (seq_users.NEXTVAL, p_email, p_password, p_full_name, 'USER');
END CreateUser;
/

-- 2.2 SearchMovies
CREATE OR REPLACE PROCEDURE SearchMovies(
  p_title     IN VARCHAR2,
  p_genre     IN VARCHAR2,
  p_year      IN NUMBER,
  cur_out     OUT SYS_REFCURSOR
) AS
BEGIN
  OPEN cur_out FOR
    SELECT m.movie_id, m.title, m.release_year, m.poster_url
      FROM movies m
      LEFT JOIN movie_genres mg ON m.movie_id = mg.movie_id
      LEFT JOIN genres g        ON mg.genre_id = g.genre_id
     WHERE (p_title IS NULL OR LOWER(m.title) LIKE '%'||LOWER(p_title)||'%')
       AND (p_genre IS NULL OR LOWER(g.name) = LOWER(p_genre))
       AND (p_year IS NULL OR m.release_year = p_year)
     ORDER BY m.title;
END SearchMovies;
/

-- 2.3 GetMovieDetails
CREATE OR REPLACE PROCEDURE GetMovieDetails(
  p_movie_id  IN NUMBER,
  cur_meta    OUT SYS_REFCURSOR,
  cur_reviews OUT SYS_REFCURSOR
) AS
BEGIN
  OPEN cur_meta FOR
    SELECT m.movie_id, m.title, m.release_year, m.description, m.poster_url, m.avg_rating,
           (SELECT LISTAGG(g.name, ', ') WITHIN GROUP (ORDER BY g.name)
              FROM movie_genres mg JOIN genres g ON mg.genre_id = g.genre_id
             WHERE mg.movie_id = m.movie_id) AS genres,
           (SELECT LISTAGG(a.name||' AS '||mc.character_name, ', ') WITHIN GROUP (ORDER BY a.name)
              FROM movie_cast mc JOIN actors a ON mc.actor_id = a.actor_id
             WHERE mc.movie_id = m.movie_id) AS cast_list
      FROM movies m
     WHERE m.movie_id = p_movie_id;

  OPEN cur_reviews FOR
    SELECT r.review_id, r.user_id, u.full_name, r.review_text, r.created_at, r.updated_at
      FROM reviews r
      JOIN users u ON r.user_id = u.user_id
     WHERE r.movie_id = p_movie_id
     ORDER BY r.created_at DESC;
END GetMovieDetails;
/

-- 2.4 SubmitRating
-- CREATE OR REPLACE PROCEDURE SubmitRating(
--   p_user_id    IN  NUMBER,
--   p_movie_id   IN  NUMBER,
--   p_value      IN  NUMBER,
--   out_msg      OUT VARCHAR2
-- ) AS
--   v_cnt INTEGER;
-- BEGIN
--   IF p_value NOT BETWEEN 1 AND 10 THEN
--     out_msg := 'Error: rating must be between 1 and 10.';
--     RETURN;
--   END IF;

--   UPDATE ratings
--      SET rating_value = p_value,
--          created_at   = SYSTIMESTAMP
--    WHERE user_id  = p_user_id
--      AND movie_id = p_movie_id;

--   v_cnt := SQL%ROWCOUNT;

--   IF v_cnt = 0 THEN
--     INSERT INTO ratings(rating_id, user_id, movie_id, rating_value, created_at)
--     VALUES (seq_ratings.NEXTVAL, p_user_id, p_movie_id, p_value, SYSTIMESTAMP);
--   END IF;

--   UPDATE movies
--      SET avg_rating = (
--        SELECT ROUND(AVG(rating_value),2)
--          FROM ratings
--         WHERE movie_id = p_movie_id
--      )
--    WHERE movie_id = p_movie_id;

--   out_msg := 'Your rating has been submitted.';
-- END SubmitRating;
-- /

-- 2.5 WriteReview
CREATE OR REPLACE PROCEDURE WriteReview(
  p_user_id   IN NUMBER,
  p_movie_id  IN NUMBER,
  p_text      IN CLOB,
  out_msg     OUT VARCHAR2
) AS
BEGIN
  IF TRIM(p_text) IS NULL THEN
    out_msg := 'Error: review text cannot be empty.';
    RETURN;
  END IF;

  INSERT INTO reviews(review_id, user_id, movie_id, review_text)
    VALUES (seq_reviews.NEXTVAL, p_user_id, p_movie_id, p_text);

  out_msg := 'Your review has been submitted.';
END WriteReview;
/

-- 2.6 EditReview
CREATE OR REPLACE PROCEDURE EditReview(
  p_review_id IN NUMBER,
  p_user_id   IN NUMBER,
  p_text      IN CLOB,
  out_msg     OUT VARCHAR2
) AS
  v_owner NUMBER;
BEGIN
  SELECT user_id INTO v_owner FROM reviews WHERE review_id = p_review_id;

  IF v_owner != p_user_id THEN
    out_msg := 'Error: cannot edit another user''s review.';
    RETURN;
  END IF;

  UPDATE reviews
     SET review_text = p_text,
         updated_at  = SYSTIMESTAMP
   WHERE review_id = p_review_id;

  out_msg := 'Your review has been updated.';
END EditReview;
/

-- 2.7 DeleteReview (Oracle 11g-compatible)
CREATE OR REPLACE PROCEDURE DeleteReview(
  p_review_id IN NUMBER,
  p_user_id   IN NUMBER,
  is_admin    IN NUMBER, -- Pass 1 for TRUE, 0 for FALSE
  out_msg     OUT VARCHAR2
) AS
  v_owner NUMBER;
BEGIN
  SELECT user_id INTO v_owner FROM reviews WHERE review_id = p_review_id;

  IF v_owner = p_user_id OR is_admin = 1 THEN
    DELETE FROM reviews WHERE review_id = p_review_id;
    out_msg := 'Review deleted.';
  ELSE
    out_msg := 'Error: insufficient privileges to delete review.';
  END IF;
END DeleteReview;
/

-- 2.8 AddToWatchlist
CREATE OR REPLACE PROCEDURE AddToWatchlist(
  p_user_id   IN NUMBER,
  p_movie_id  IN NUMBER,
  out_msg     OUT VARCHAR2
) AS
BEGIN
  INSERT INTO watchlists(watchlist_id, user_id, movie_id)
    VALUES (seq_watchlists.NEXTVAL, p_user_id, p_movie_id);

  out_msg := 'Title successfully added to your watchlist.';
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    out_msg := 'Error: title already in your watchlist.';
END AddToWatchlist;
/

-- 2.9 RemoveFromWatchlist
CREATE OR REPLACE PROCEDURE RemoveFromWatchlist(
  p_user_id   IN NUMBER,
  p_movie_id  IN NUMBER,
  out_msg     OUT VARCHAR2
) AS
BEGIN
  DELETE FROM watchlists
   WHERE user_id = p_user_id AND movie_id = p_movie_id;

  out_msg := 'Title removed from your watchlist.';
END RemoveFromWatchlist;
/

-- 2.10 DeleteMovie
CREATE OR REPLACE PROCEDURE DeleteMovie(
  p_admin_id  IN NUMBER,
  p_movie_id  IN NUMBER,
  out_msg     OUT VARCHAR2
) AS
BEGIN
  DELETE FROM movies WHERE movie_id = p_movie_id;
  out_msg := 'Movie has been deleted.';
END DeleteMovie;
/
-- Insert 10+ users
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'user1@example.com', 'hash1', 'User One', 'USER');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'user2@example.com', 'hash2', 'User Two', 'USER');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'user3@example.com', 'hash3', 'User Three', 'USER');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'user4@example.com', 'hash4', 'User Four', 'USER');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'user5@example.com', 'hash5', 'User Five', 'USER');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'user6@example.com', 'hash6', 'User Six', 'USER');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'user7@example.com', 'hash7', 'User Seven', 'USER');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'user8@example.com', 'hash8', 'User Eight', 'USER');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'admin1@example.com', 'hash9', 'Admin One', 'ADMIN');
INSERT INTO users (user_id, email, password_hash, full_name, role) VALUES (seq_users.NEXTVAL, 'admin2@example.com', 'hash10', 'Admin Two', 'ADMIN');

-- Insert 10 actors
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor One');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Two');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Three');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Four');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Five');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Six');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Seven');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Eight');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Nine');
INSERT INTO actors (actor_id, name) VALUES (seq_actors.NEXTVAL, 'Actor Ten');

-- Insert 10 movies
INSERT INTO movie_genres (movie_id, genre_id) VALUES (1, 1);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (2, 2);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (3, 3);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (4, 4);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (5, 5);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (6, 6);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (7, 7);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (8, 8);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (9, 9);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (10, 10);

-- Insert 10 movie_cast (assuming actor_id 1–10)
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (1, 1, 'Hero');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (2, 2, 'Sidekick');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (3, 3, 'Villain');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (4, 4, 'Detective');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (5, 5, 'Wizard');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (6, 6, 'Alien');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (7, 7, 'Princess');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (8, 8, 'Spy');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (9, 9, 'Doctor');
INSERT INTO movie_cast (movie_id, actor_id, character_name) VALUES (10, 10, 'Agent');

-- -- Insert 10 ratings (assuming user_id 1–10, movie_id 1–10)
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 1, 1, 9, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 2, 2, 8, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 3, 3, 7, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 4, 4, 10, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 5, 5, 6, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 6, 6, 5, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 7, 7, 9, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 8, 8, 8, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 9, 9, 7, SYSTIMESTAMP);
-- INSERT INTO ratings (rating_id, user_id, movie_id, rating_value, created_at) VALUES (seq_ratings.NEXTVAL, 10, 10, 6, SYSTIMESTAMP);

-- Insert 10 reviews (assuming user_id 1–10, movie_id 1–10)
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 1, 1, 'Amazing movie!', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 2, 2, 'Loved the visuals.', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 3, 3, 'Good plot.', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 4, 4, 'Great performance.', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 5, 5, 'Entertaining!', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 6, 6, 'Not bad.', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 7, 7, 'Could be better.', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 8, 8, 'Enjoyed it.', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 9, 9, 'Nice soundtrack.', SYSTIMESTAMP);
INSERT INTO reviews (review_id, user_id, movie_id, review_text, created_at) VALUES (seq_reviews.NEXTVAL, 10, 10, 'Too long.', SYSTIMESTAMP);

-- Insert 10 watchlists (assuming user_id 1–10, movie_id shifted for variety)
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 1, 2, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 2, 3, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 3, 4, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 4, 5, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 5, 6, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 6, 7, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 7, 8, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 8, 9, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 9, 10, SYSTIMESTAMP);
INSERT INTO watchlists (watchlist_id, user_id, movie_id, added_at) VALUES (seq_watchlists.NEXTVAL, 10, 1, SYSTIMESTAMP);