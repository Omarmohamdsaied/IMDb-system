using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml.Linq;


using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace SWELab1
{
    public partial class RegisterationForm : Form
    {
        string ordb = "User Id=sys; Password=Administrator1; Data Source=localhost:1521/orcl;DBA Privilege=SYSDBA;";
        OracleConnection conn;
        public RegisterationForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            string name = textBox1.Text.Trim();
            string email = textBox2.Text.Trim();
            string password = textBox3.Text;
            string confirmPassword = textBox4.Text;

            // Validation
            if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(confirmPassword))
            {
                MessageBox.Show("Please fill in all fields.");
                return;
            }

            if (password != confirmPassword)
            {
                MessageBox.Show("Passwords do not match.");
                return;
            }

            // string connString = "User Id=your_user;Password=your_password;Data Source=your_datasource;";
            using (OracleConnection conn = new OracleConnection(ordb))
            {
                try
                {
                    conn.Open();
                    string insertQuery = "INSERT INTO users (name, email, password, role) VALUES (:name, :email, :password, 'user')";
                    using (OracleCommand cmd = new OracleCommand(insertQuery, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("name", name));
                        cmd.Parameters.Add(new OracleParameter("email", email));
                        cmd.Parameters.Add(new OracleParameter("password", password));


                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Registration successful!");

                        this.Close(); // Optionally return to login form
                    }
                }
                catch (OracleException ex)
                {
                    if (ex.Number == 1)
                        MessageBox.Show("This email is already registered.");
                    else
                        MessageBox.Show("Database error: " + ex.Message);
                }

            }
        }

               private void RegisterationForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

    }



}

