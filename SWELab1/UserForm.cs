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
using static SWELab1.AdminForm;
using CrystalDecisions.Shared;


namespace SWELab1
{
    public partial class UserForm : Form
    {
        string ordb = "User Id=sys; Password=Administrator1; Data Source=localhost:1521/orcl;DBA Privilege=SYSDBA;";
        OracleConnection conn;
        OracleDataAdapter adapter;
        DataSet ds;
        private string userId;
        //
        CrystalReport1 CR1;
        CrystalReport2 CR2;
        public UserForm(string id)
        {
            InitializeComponent();
            userId = id;
        }

        private void UserForm_Load(object sender, EventArgs e)
        {
            LoadMovies();
            CR1 = new CrystalReport1();
            CR2 = new CrystalReport2();
            //LoadMoviesIntoCards();
        }

   

        private void LoadMovies()
        {
            try
            {
                OracleConnection o = new OracleConnection(ordb); // Make sure this is set correctly
                o.Open(); // Open the connection


                OracleCommand cmd = new OracleCommand("GET_ALL_MOVIES", o);
                cmd.CommandType = CommandType.StoredProcedure;

                // Define the output parameter (REF CURSOR)
                cmd.Parameters.Add("p_cursor", OracleDbType.RefCursor).Direction = ParameterDirection.Output;

                adapter = new OracleDataAdapter(cmd);
                ds = new DataSet();
                adapter.Fill(ds);

                // Set primary key for update/delete to work
                DataColumn[] keyColumns = new DataColumn[1];
                keyColumns[0] = ds.Tables[0].Columns["id"];
                ds.Tables[0].PrimaryKey = keyColumns;

                dataGridView1.DataSource = ds.Tables[0];
                dataGridView1.AllowUserToAddRows = false;
                dataGridView1.Columns["id"].Visible = false;
                dataGridView1.AllowUserToResizeColumns = true;
                dataGridView1.Columns["description"].Width = 300; // adjust width as needed
            }
            catch (OracleException ex)
            {
                MessageBox.Show("Oracle Error: " + ex.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show("General Error: " + ex.Message);
            }
        }




        private void UserForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            //Application.Exit();
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



        private void UserForm_FormClosing(object sender, FormClosedEventArgs e)
        {
            //Application.Exit();
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

   

        private void DisplayMovieDetails(string movieId)
        {
            MovieDetailsForm movieForm = new MovieDetailsForm(movieId, userId);
            movieForm.Owner = this;  
            movieForm.Show();       
            this.Hide();            
        }


        private void dataGridView1_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        {
            // Check if a valid row is clicked (not the header row)
            if (e.RowIndex >= 0)
            {
              
                string movieId = dataGridView1.Rows[e.RowIndex].Cells["id"].Value.ToString();
                //MessageBox.Show("Movie ID: " + movieId);              
                DisplayMovieDetails(movieId);
              
            }
           
           
        }
        private void button2_Click(object sender, EventArgs e)
        {
            CR1.SetParameterValue(0, Convert.ToDateTime(textBox2.Text));
            CR1.SetParameterValue(1, Convert.ToDateTime(textBox3.Text));
            crystalReportViewer1.ReportSource = CR1;
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            crystalReportViewer2.ReportSource = CR2;
        }
    }

}
