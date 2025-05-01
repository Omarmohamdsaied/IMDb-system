using System;
using System.IO;

using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace SWELab1
{
    public partial class MovieDetailsForm : Form
    {
        string ordb = "User Id=sys; Password=Administrator1; Data Source=localhost:1521/orcl;DBA Privilege=SYSDBA;";


        private string movieId;
        private string userId;

        public MovieDetailsForm(string id,string userId)
        {
            InitializeComponent();
            movieId = id;
            this.userId = userId;
        }

        private void MovieDetailsForm_Load(object sender, EventArgs e)
        {
            LoadMovieDetails();
        }

       


        private void LoadMovieDetails()
        {
            try
            {
                using (OracleConnection conn = new OracleConnection(ordb))
                {
                    conn.Open();
                    
                    // --- Load Movie Details ---
                    string movieQuery = "SELECT id,title, avgrating, release_date, description,poster_url  FROM movies WHERE id = :movieId";
                    OracleCommand movieCmd = new OracleCommand(movieQuery, conn);
                    movieCmd.Parameters.Add("movieId", movieId);

                    using (OracleDataReader reader = movieCmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            label1.Text = "Movie Title: " + reader["title"].ToString();
                            label2.Text = "Rating: " + reader["avgrating"].ToString();
                            label3.Text = "Release Date: " + Convert.ToDateTime(reader["release_date"]).ToString("yyyy-MM-dd");
                            label4.Text = "Description: " + reader["description"].ToString();


                            string posterPath = reader["poster_url"].ToString();
                            if (File.Exists(posterPath))
                            {
                                pictureBox1.Image = Image.FromFile(posterPath);
                            }
                            else
                            {
                                // Optional: Show default image or clear the picture box
                                pictureBox1.Image = null;
                            }

                        }
                    }

                    // --- Load Actors using JOIN on actor_movies ---
                    string actorQuery = @"
                        SELECT a.id , a.name
                        FROM actors a
                        JOIN actor_movies am ON a.id = am.actor_id
                        WHERE am.movie_id = :movieId";

                    OracleCommand actorCmd = new OracleCommand(actorQuery, conn);
                    actorCmd.Parameters.Add("movieId", movieId);

                    OracleDataAdapter adapter = new OracleDataAdapter(actorCmd);
                    DataTable actorTable = new DataTable();
                    adapter.Fill(actorTable);

                   // dataGridView1.DataSource = actorTable;

                    flowLayoutPanel1.Controls.Clear();
                    foreach (DataRow row in actorTable.Rows)
                    {
                        Label actorLabel = new Label();
                        actorLabel.Text = $" {row["name"]} , ";
                        actorLabel.AutoSize = true;
                        actorLabel.Margin = new Padding(5);
                        flowLayoutPanel1.Controls.Add(actorLabel);
                    }

                    string checkQuery = "SELECT COUNT(*) FROM likes WHERE movie_id = :movieId AND user_id = :userId";
                    OracleCommand checkCmd = new OracleCommand(checkQuery, conn);
                    checkCmd.Parameters.Add("movieId", movieId);  // movieId should be a class-level variable
                    checkCmd.Parameters.Add("userId", userId);    // userId should be passed to the form and stored

                    int likeExists = Convert.ToInt32(checkCmd.ExecuteScalar());
                    if(likeExists > 0)
                        button1.Text = "remove like 💔";
                    else
                    button1.Text = "Like ❤️";

                 


                    // --- Get total like count for the movie ---
                    string likeCountQuery = "SELECT COUNT(*) FROM likes WHERE movie_id = :movieId";
                    OracleCommand likeCountCmd = new OracleCommand(likeCountQuery, conn);
                    likeCountCmd.Parameters.Add("movieId", movieId);

                    int totalLikes = Convert.ToInt32(likeCountCmd.ExecuteScalar());
                    labelLikeCount.Text = $"Total Likes: {totalLikes}";
                    // --- Load Reviews with User Name ---
                    string reviewQuery = @"
                    SELECT u.name AS ""User Name"", r.text AS ""Review""
                    FROM reviews r
                    JOIN users u ON r.user_id = u.id
                    WHERE r.movie_id = :movieId";

                    OracleCommand reviewCmd = new OracleCommand(reviewQuery, conn);
                    reviewCmd.Parameters.Add("movieId", movieId);

                    OracleDataAdapter reviewAdapter = new OracleDataAdapter(reviewCmd);
                    DataTable reviewTable = new DataTable();
                    reviewAdapter.Fill(reviewTable);

                    // Bind to DataGridView2
                    dataGridView2.DataSource = reviewTable;
                    dataGridView2.AllowUserToAddRows = false;
                    dataGridView2.ClearSelection();


                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }








        private void label1_Click(object sender, EventArgs e)
        {

        }
        private void button1_Click(object sender, EventArgs e)
        {
            using (OracleConnection conn = new OracleConnection(ordb))
            {
                try
                {
                    conn.Open();

                    // Step 1: Check if the like already exists
                    string checkQuery = "SELECT COUNT(*) FROM likes WHERE movie_id = :movieId AND user_id = :userId";
                    OracleCommand checkCmd = new OracleCommand(checkQuery, conn);
                    checkCmd.Parameters.Add("movieId", movieId);  // movieId should be a class-level variable
                    checkCmd.Parameters.Add("userId", userId);    // userId should be passed to the form and stored

                    int likeExists = Convert.ToInt32(checkCmd.ExecuteScalar());

                    OracleCommand actionCmd;

                    if (likeExists > 0)
                    {
                        // Step 2: User already liked it → Remove like
                        string deleteQuery = "DELETE FROM likes WHERE movie_id = :movieId AND user_id = :userId";
                        actionCmd = new OracleCommand(deleteQuery, conn);
                        actionCmd.Parameters.Add("movieId", movieId);
                        actionCmd.Parameters.Add("userId", userId);
                        actionCmd.ExecuteNonQuery();
                        button1.Text = "Like ❤️";
                        MessageBox.Show("Like removed.");
                    }
                    else
                    {
                        // Step 3: User hasn't liked → Insert new like
                        string insertQuery = "INSERT INTO likes (movie_id, user_id) VALUES (:movieId, :userId)";
                        actionCmd = new OracleCommand(insertQuery, conn);
                        actionCmd.Parameters.Add("movieId", movieId);
                        actionCmd.Parameters.Add("userId", userId);
                        actionCmd.ExecuteNonQuery();

                        button1.Text = "remove like 💔";
                        MessageBox.Show("Movie liked!");
                    } 
                    // --- Get total like count for the movie ---
                    string likeCountQuery = "SELECT COUNT(*) FROM likes WHERE movie_id = :movieId";
                    OracleCommand likeCountCmd = new OracleCommand(likeCountQuery, conn);
                    likeCountCmd.Parameters.Add("movieId", movieId);

                    int totalLikes = Convert.ToInt32(likeCountCmd.ExecuteScalar());
                    labelLikeCount.Text = $"Total Likes: {totalLikes}";

                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }

        }
        private void MovieDetailsForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            Application.Exit();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string reviewText = textBox1.Text.Trim();

            if (string.IsNullOrWhiteSpace(reviewText))
            {
                MessageBox.Show("Please write a review before submitting.");
                return;
            }

            using (OracleConnection conn = new OracleConnection(ordb))
            {
                try
                {
                    conn.Open();

                    // Check if the user has already reviewed this movie
                    string checkReviewQuery = @"
                SELECT COUNT(*) 
                FROM reviews 
                WHERE movie_id = :movieId AND user_id = :userId";

                    using (OracleCommand checkCmd = new OracleCommand(checkReviewQuery, conn))
                    {
                        checkCmd.Parameters.Add("movieId", movieId);
                        checkCmd.Parameters.Add("userId", userId);

                        int reviewCount = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (reviewCount > 0)
                        {
                            MessageBox.Show("You have already reviewed this movie.");
                            return;  // Prevent further action if the user already has a review
                        }
                    }

                    // Proceed with inserting the review if not already done
                    string insertReviewQuery = @"
                INSERT INTO reviews (id, text, movie_id, user_id)
                VALUES (review_seq.nextval, :text, :movieId, :userId)";

                    using (OracleCommand cmd = new OracleCommand(insertReviewQuery, conn))
                    {
                        cmd.Parameters.Add("text", reviewText);
                        cmd.Parameters.Add("movieId", movieId);
                        cmd.Parameters.Add("userId", userId);

                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Review submitted successfully!");
                        textBox1.Clear();

                        // Reload reviews into DataGridView
                        string reviewQuery = @"
                    SELECT u.name AS ""User Name"", r.text AS ""Review""
                    FROM reviews r
                    JOIN users u ON r.user_id = u.id
                    WHERE r.movie_id = :movieId";

                        OracleCommand reviewCmd = new OracleCommand(reviewQuery, conn);
                        reviewCmd.Parameters.Add("movieId", movieId);

                        OracleDataAdapter reviewAdapter = new OracleDataAdapter(reviewCmd);
                        DataTable reviewTable = new DataTable();
                        reviewAdapter.Fill(reviewTable);

                        // Bind to DataGridView2
                        dataGridView2.DataSource = reviewTable;
                        dataGridView2.AllowUserToAddRows = false;
                    }
                }
                catch (OracleException ex)
                {
                    MessageBox.Show("Database error: " + ex.Message);
                }
            }
        }

        private void labelLikeCount_Click(object sender, EventArgs e)
        {

        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (this.Owner != null)
            {
                this.Owner.Show();   // Show the previous form
            }
            else
            {
                Application.Exit();  // If no owner, ensure app shuts down
            }
            this.Close();            // Close the current form
        }

    }

}
