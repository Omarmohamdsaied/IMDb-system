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
