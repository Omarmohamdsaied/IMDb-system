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
        private string userId;
        DataSet ds;

     
        public AdminForm(string userId)
        {
            this.FormClosing += AdminForm_FormClosing;
            InitializeComponent();
            this.userId = userId;
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
                string query = "SELECT id, title, avgrating, release_date, description FROM movies";
                adapter = new OracleDataAdapter(query, ordb);
                ds = new DataSet();
                adapter.Fill(ds);

                // Set primary key for update/delete to work
                DataColumn[] keyColumns = new DataColumn[1];
                keyColumns[0] = ds.Tables[0].Columns["id"];
                ds.Tables[0].PrimaryKey = keyColumns;

                dataGridView1.DataSource = ds.Tables[0];
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
                //Console.WriteLine(movieId);
                // Pass the movie ID to the new form to display movie details
                DisplayMovieDetails(movieId);
            }
        }




        private void DisplayMovieDetails(string movieId)
        {
            MovieDetailsForm movieForm = new MovieDetailsForm(movieId,userId);
            movieForm.ShowDialog(); // Opens the MovieDetailsForm as a modal
        }


        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            builder = new OracleCommandBuilder(adapter);
            adapter.Update(ds.Tables[0]);
        }

   

        private void button3_Click(object sender, EventArgs e)
        {
            if (dataGridView1.CurrentRow != null)
            {
                int index = dataGridView1.CurrentRow.Index;
                if (index >= 0 && index < ds.Tables[0].Rows.Count)
                {
                    ds.Tables[0].Rows[index].Delete(); // Mark row as deleted
                    
                    try
                    {
                        builder = new OracleCommandBuilder(adapter);
                        adapter.Update(ds.Tables[0]);  // Apply deletion to DB

                        // Reload to reflect updated data
                        LoadMovies();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Error deleting row: " + ex.Message);
                    }
                }
            }
        }
        private void AdminForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            Application.Exit();
            //Application.Exit();
            foreach (Form form in Application.OpenForms)
            {
                if (form != this) // Skip the current form if you don't want to close it
                {
                    form.Close();
                }
            }
            Application.Exit();
        }
    }
}


