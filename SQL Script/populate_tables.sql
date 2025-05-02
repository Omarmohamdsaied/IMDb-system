
-- Insert users
INSERT INTO users (email, password_hash, full_name, role) VALUES ('user1@example.com', 'hash1', 'User One', 'USER');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('user2@example.com', 'hash2', 'User Two', 'USER');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('user3@example.com', 'hash3', 'User Three', 'USER');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('user4@example.com', 'hash4', 'User Four', 'USER');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('user5@example.com', 'hash5', 'User Five', 'USER');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('admin1@example.com', 'hash6', 'Admin One', 'ADMIN');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('admin2@example.com', 'hash7', 'Admin Two', 'ADMIN');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('user6@example.com', 'hash8', 'User Six', 'USER');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('user7@example.com', 'hash9', 'User Seven', 'USER');
INSERT INTO users (email, password_hash, full_name, role) VALUES ('user8@example.com', 'hash10', 'User Eight', 'USER');

-- Insert genres
INSERT INTO genres (name) VALUES ('Action');
INSERT INTO genres (name) VALUES ('Drama');
INSERT INTO genres (name) VALUES ('Comedy');
INSERT INTO genres (name) VALUES ('Sci-Fi');
INSERT INTO genres (name) VALUES ('Fantasy');
INSERT INTO genres (name) VALUES ('Thriller');
INSERT INTO genres (name) VALUES ('Romance');
INSERT INTO genres (name) VALUES ('Animation');
INSERT INTO genres (name) VALUES ('Mystery');
INSERT INTO genres (name) VALUES ('Horror');

-- Insert actors
INSERT INTO actors (name) VALUES ('Actor One');
INSERT INTO actors (name) VALUES ('Actor Two');
INSERT INTO actors (name) VALUES ('Actor Three');
INSERT INTO actors (name) VALUES ('Actor Four');
INSERT INTO actors (name) VALUES ('Actor Five');
INSERT INTO actors (name) VALUES ('Actor Six');
INSERT INTO actors (name) VALUES ('Actor Seven');
INSERT INTO actors (name) VALUES ('Actor Eight');
INSERT INTO actors (name) VALUES ('Actor Nine');
INSERT INTO actors (name) VALUES ('Actor Ten');

-- Insert movies
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie One', 2015, 'Desc one', '/img/1.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Two', 2016, 'Desc two', '/img/2.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Three', 2017, 'Desc three', '/img/3.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Four', 2018, 'Desc four', '/img/4.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Five', 2019, 'Desc five', '/img/5.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Six', 2020, 'Desc six', '/img/6.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Seven', 2021, 'Desc seven', '/img/7.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Eight', 2022, 'Desc eight', '/img/8.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Nine', 2023, 'Desc nine', '/img/9.jpg');
INSERT INTO movies (title, release_year, description, poster_url) VALUES ('Movie Ten', 2024, 'Desc ten', '/img/10.jpg');

-- Insert movie_genres
INSERT INTO movie_genres VALUES (1, 1);
INSERT INTO movie_genres VALUES (2, 2);
INSERT INTO movie_genres VALUES (3, 3);
INSERT INTO movie_genres VALUES (4, 4);
INSERT INTO movie_genres VALUES (5, 5);
INSERT INTO movie_genres VALUES (6, 6);
INSERT INTO movie_genres VALUES (7, 7);
INSERT INTO movie_genres VALUES (8, 8);
INSERT INTO movie_genres VALUES (9, 9);
INSERT INTO movie_genres VALUES (10, 10);

-- Insert movie_cast
INSERT INTO movie_cast VALUES (1, 1, 'Hero');
INSERT INTO movie_cast VALUES (2, 2, 'Sidekick');
INSERT INTO movie_cast VALUES (3, 3, 'Villain');
INSERT INTO movie_cast VALUES (4, 4, 'Detective');
INSERT INTO movie_cast VALUES (5, 5, 'Warrior');
INSERT INTO movie_cast VALUES (6, 6, 'Alien');
INSERT INTO movie_cast VALUES (7, 7, 'Princess');
INSERT INTO movie_cast VALUES (8, 8, 'Spy');
INSERT INTO movie_cast VALUES (9, 9, 'Doctor');
INSERT INTO movie_cast VALUES (10, 10, 'Agent');

-- Insert ratings
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (1, 1, 8, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (2, 2, 9, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (3, 3, 7, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (4, 4, 6, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (5, 5, 9, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (6, 6, 10, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (7, 7, 7, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (8, 8, 8, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (9, 9, 6, SYSTIMESTAMP);
INSERT INTO ratings (user_id, movie_id, rating_value, created_at) VALUES (10, 10, 7, SYSTIMESTAMP);

-- Insert reviews
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (1, 1, 'Amazing!', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (2, 2, 'Great movie!', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (3, 3, 'Not bad', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (4, 4, 'Could be better', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (5, 5, 'Loved it', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (6, 6, 'Excellent visuals', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (7, 7, 'Too long', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (8, 8, 'Nice soundtrack', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (9, 9, 'Scary!', SYSTIMESTAMP);
INSERT INTO reviews (user_id, movie_id, review_text, created_at) VALUES (10, 10, 'Mind-blowing!', SYSTIMESTAMP);

-- Insert watchlists
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (1, 2, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (2, 3, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (3, 4, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (4, 5, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (5, 6, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (6, 7, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (7, 8, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (8, 9, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (9, 10, SYSTIMESTAMP);
INSERT INTO watchlists (user_id, movie_id, added_at) VALUES (10, 1, SYSTIMESTAMP);
