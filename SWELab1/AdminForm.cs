using System;
using System.Collections;
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


namespace SWELab1
{
    public partial class AdminForm : Form
    {

        string ordb = "User Id=sys; Password=Administrator1; Data Source=localhost:1521/orcl;DBA Privilege=SYSDBA;";
        OracleConnection conn;
        OracleDataAdapter adapter;
        OracleCommandBuilder builder;
        DataSet ds;

        List<Movie> movies = new List<Movie>
        {
           new Movie { Title = "The Godfather", AvgRating = 9.2, ReleaseDate = new DateTime(1972, 3, 24), Description = "Crime drama" },
           new Movie { Title = "Interstellar", AvgRating = 8.6, ReleaseDate = new DateTime(2014, 11, 7), Description = "Sci-fi epic" },
           new Movie { Title = "Scent of a Woman", AvgRating = 8.0, ReleaseDate = new DateTime(1992, 12, 23), Description = "Drama" }
        };
        public AdminForm()
        {
            InitializeComponent();
        }

        private void AdminForm_Load(object sender, EventArgs e)
        {
            LoadMovies();
        }
        public class Movie
        {
            public string Title { get; set; }
            public double AvgRating { get; set; }
            public DateTime ReleaseDate { get; set; }
            public string Description { get; set; }
        }

        private void LoadMovies()
        {
            try
            {
                // string query = "SELECT  title ,avgrating, release_date, description  FROM movies";

                //adapter = new OracleDataAdapter(query, ordb); // Pass the connection object, not string
                //ds = new DataSet();
                //adapter.Fill(ds);

                //dataGridView1.DataSource = ds.Tables[0];

             

                dataGridView1.DataSource = movies;


            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }


        private void LoadMovies(string searchTerm = "")
        {
            try
            {
                //// Build the SQL query with a LIKE clause for searching titles (case-insensitive)
                //string query = "SELECT title, avgrating, release_date, description FROM movies";

                //// If searchTerm is not empty, append the LIKE clause with UPPER() for case-insensitivity
                //if (!string.IsNullOrEmpty(searchTerm))
                //{
                //    query += " WHERE UPPER(title) LIKE UPPER(:searchTerm)";
                //}

                //// Create an OracleCommand and pass the searchTerm as a parameter
                //OracleCommand cmd = new OracleCommand(query, new OracleConnection(ordb));
                //cmd.Parameters.Add(new OracleParameter("searchTerm", "%" + searchTerm + "%"));

                //// Use OracleDataAdapter to fill the DataSet with search results
                //adapter = new OracleDataAdapter(cmd);
                //ds = new DataSet();
                //adapter.Fill(ds);

                //// Bind the results to DataGridView
                //dataGridView1.DataSource = ds.Tables[0];



            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }



        private void dataGridView1_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        {
            // Check if a valid row is clicked (not the header row)
            if (e.RowIndex >= 0)
            {
                // Get the movie ID from the clicked row (assuming the 'id' is in the first column)
                //string movieId = dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString();
                string movieId = dataGridView1.Rows[e.RowIndex].Cells["id"].Value.ToString();

                // Pass the movie ID to the new form to display movie details
                DisplayMovieDetails(movieId);
            }
        }




        private void DisplayMovieDetails(string movieId)
        {
            MovieDetailsForm movieForm = new MovieDetailsForm(movieId);
            movieForm.ShowDialog(); // Opens the MovieDetailsForm as a modal
        }

        //private void dataGridView1_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        //{

        //}

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            //builder = new OracleCommandBuilder(adapter);
            //adapter.Update(ds.Tables[0]);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (dataGridView1.CurrentRow != null)
            {
                int index = dataGridView1.CurrentRow.Index;

                if (index >= 0 && index < movies.Count)
                {
                    movies.RemoveAt(index);
                    dataGridView1.DataSource = null;
                    dataGridView1.DataSource = movies;
                }
            }
        }
    }
}
