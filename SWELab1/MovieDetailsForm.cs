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
    public partial class MovieDetailsForm : Form
    {
        string ordb = "User Id=sys; Password=Administrator1; Data Source=localhost:1521/orcl;DBA Privilege=SYSDBA;";


        private string movieId;

        public MovieDetailsForm(string id)
        {
            InitializeComponent();
            movieId = id;
        }

        private void MovieDetailsForm_Load(object sender, EventArgs e)
        {
            LoadMovieDetails();
        }

        private void LoadMovieDetails()
        {
            try
            {
                string query = "SELECT title, avgrating, release_date, description FROM movies WHERE id = :movieId";

                OracleCommand cmd = new OracleCommand(query, new OracleConnection(ordb));
                cmd.Parameters.Add(new OracleParameter("movieId", movieId));

                OracleDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Populate the labels or other controls with the data
                    label1.Text = reader["title"].ToString();
                    label2.Text = "Rating: " + reader["avgrating"].ToString();
                    label3.Text = "Release Date: " + reader["release_date"].ToString();
                    label4.Text = reader["description"].ToString();
                }
                else
                {
                    MessageBox.Show("Movie not found!");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }


    }
}
