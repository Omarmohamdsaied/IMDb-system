using System;
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
    public partial class UserForm : Form
    {
        string ordb = "User Id=sys; Password=Administrator1; Data Source=localhost:1521/orcl;DBA Privilege=SYSDBA;";
        OracleConnection conn;
        OracleDataAdapter adapter;
        DataSet ds;
        public UserForm()
        {
            InitializeComponent();
        }

        private void UserForm_Load(object sender, EventArgs e)
        {
            LoadMovies();
            //LoadMoviesIntoCards();
        }

        private void LoadMovies()
        {
            try
            {
                //using (OracleConnection conn = new OracleConnection(ordb))
                //{
                    //conn.Open();

                    string query = "SELECT  title ,avgrating, release_date, description  FROM movies";

                    adapter = new OracleDataAdapter(query, ordb); // Pass the connection object, not string
                    ds = new DataSet();
                    adapter.Fill(ds);

                    dataGridView1.DataSource = ds.Tables[0];
                //}
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }


        private void UserForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string searchTerm = textBox1.Text.Trim();

            // Call LoadMovies and pass the search term
            LoadMovies(searchTerm);
        }
        private void LoadMovies(string searchTerm = "")
        {
            try
            {
                // Build the SQL query with a LIKE clause for searching titles (case-insensitive)
                string query = "SELECT title, avgrating, release_date, description FROM movies";

                // If searchTerm is not empty, append the LIKE clause with UPPER() for case-insensitivity
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " WHERE UPPER(title) LIKE UPPER(:searchTerm)";
                }

                // Create an OracleCommand and pass the searchTerm as a parameter
                OracleCommand cmd = new OracleCommand(query, new OracleConnection(ordb));
                cmd.Parameters.Add(new OracleParameter("searchTerm", "%" + searchTerm + "%"));

                // Use OracleDataAdapter to fill the DataSet with search results
                adapter = new OracleDataAdapter(cmd);
                ds = new DataSet();
                adapter.Fill(ds);

                // Bind the results to DataGridView
                dataGridView1.DataSource = ds.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
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


    }

}
