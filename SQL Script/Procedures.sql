-- 2.1 CreateUser
CREATE OR REPLACE PROCEDURE CreateUser(
  p_email      IN VARCHAR2,
  p_password   IN VARCHAR2,    -- already hashed
  p_full_name  IN VARCHAR2
) AS
BEGIN
  INSERT INTO users(email, password_hash, full_name, role)
    VALUES (p_email, p_password, p_full_name, 'USER');
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
     WHERE   (p_title IS NULL OR LOWER(m.title) LIKE '%'||LOWER(p_title)||'%')
       AND   (p_genre IS NULL OR LOWER(g.name) = LOWER(p_genre))
       AND   (p_year  IS NULL OR m.release_year = p_year)
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
  -- metadata + avg_rating + aggregated genres & cast
  OPEN cur_meta FOR
    SELECT m.*, 
           LISTAGG(g.name, ', ')       WITHIN GROUP (ORDER BY g.name) AS genres,
           LISTAGG(a.name||' AS '||mc.character_name, ', ')
             WITHIN GROUP (ORDER BY a.name) AS cast_list
      FROM movies m
      LEFT JOIN movie_genres mg ON m.movie_id = mg.movie_id
      LEFT JOIN genres g        ON mg.genre_id = g.genre_id
      LEFT JOIN movie_cast mc   ON m.movie_id = mc.movie_id
      LEFT JOIN actors a        ON mc.actor_id = a.actor_id
     WHERE m.movie_id = p_movie_id
  GROUP BY m.movie_id, m.title, m.release_year, m.description, m.poster_url, m.avg_rating;

  -- user reviews
  OPEN cur_reviews FOR
    SELECT r.review_id, r.user_id, u.full_name, r.review_text, r.created_at, r.updated_at
      FROM reviews r
      JOIN users u ON r.user_id = u.user_id
     WHERE r.movie_id = p_movie_id
     ORDER BY r.created_at DESC;
END GetMovieDetails;
/

-- 2.4 SubmitRating
CREATE OR REPLACE PROCEDURE SubmitRating(
  p_user_id    IN  NUMBER,
  p_movie_id   IN  NUMBER,
  p_value      IN  NUMBER,
  out_msg      OUT VARCHAR2
) AS
  v_cnt INTEGER;
BEGIN
  IF p_value NOT BETWEEN 1 AND 10 THEN
    out_msg := 'Error: rating must be between 1 and 10.';
    RETURN;
  END IF;

  -- Try to update an existing rating
  UPDATE ratings
     SET rating_value = p_value,
         created_at   = SYSTIMESTAMP
   WHERE user_id  = p_user_id
     AND movie_id = p_movie_id;

  v_cnt := SQL%ROWCOUNT;

  -- If no row was updated, insert a new one
  IF v_cnt = 0 THEN
    INSERT INTO ratings(user_id, movie_id, rating_value, created_at)
    VALUES (p_user_id, p_movie_id, p_value, SYSTIMESTAMP);
  END IF;

  -- Recalculate the average
  UPDATE movies
     SET avg_rating = (
       SELECT ROUND(AVG(rating_value),2)
         FROM ratings
        WHERE movie_id = p_movie_id
     )
   WHERE movie_id = p_movie_id;

  out_msg := 'Your rating has been submitted.';
END SubmitRating;
/

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
  INSERT INTO reviews(user_id, movie_id, review_text)
    VALUES (p_user_id, p_movie_id, p_text);
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
     SET review_text = p_text, updated_at = SYSTIMESTAMP
   WHERE review_id = p_review_id;
  out_msg := 'Your review has been updated.';
END EditReview;
/

-- 2.7 DeleteReview
CREATE OR REPLACE PROCEDURE DeleteReview(
  p_review_id IN NUMBER,
  p_user_id   IN NUMBER,
  is_admin    IN BOOLEAN,
  out_msg     OUT VARCHAR2
) AS
  v_owner NUMBER;
BEGIN
  SELECT user_id INTO v_owner FROM reviews WHERE review_id = p_review_id;
  IF v_owner = p_user_id OR is_admin THEN
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
  INSERT INTO watchlists(user_id, movie_id)
    VALUES (p_user_id, p_movie_id);
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
   WHERE user_id = p_user_id
     AND movie_id = p_movie_id;
  out_msg := 'Title removed from your watchlist.';
END RemoveFromWatchlist;
/

-- 2.10 DeleteMovie (Admin only)
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