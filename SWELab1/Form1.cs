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
    public partial class LogIn : Form
    {
       //string ordb = "data source =orcl ; user Id=scott ; password = tiger;";
        string ordb = "User Id=sys; Password=Administrator1; Data Source=localhost:1521/orcl;DBA Privilege=SYSDBA;";
        OracleConnection conn;

        public LogIn()
        {
            InitializeComponent();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
           
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            conn=new OracleConnection(ordb);
            conn.Open();

            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn;

            cmd.CommandText = "select * from actors";
            cmd.CommandType = CommandType.Text;

            OracleDataReader reader = cmd.ExecuteReader();
            /*while (reader.Read())
            {
                comboBox1.Items.Add(reader[0]);
            }
            reader.Close();*/



        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            conn.Dispose();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            using (OracleConnection conn = new OracleConnection(ordb))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT role FROM users WHERE email = :email AND password = :password";
                    using (OracleCommand cmd = new OracleCommand(query, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("email", Email.Text));
                        cmd.Parameters.Add(new OracleParameter("password", textBox2.Text));

                        object roleObj = cmd.ExecuteScalar();

                        if (roleObj != null)
                        {
                            string role = roleObj.ToString();
                           // MessageBox.Show("Login successful! Role: " + role);

                            // Redirect based on role
                            if (role == "user")
                            {
                                UserForm userForm = new UserForm();
                                userForm.Show();
                            }
                            else if (role == "admin")
                            {
                                AdminForm adminForm = new AdminForm();
                                adminForm.Show();
                            }

                            this.Hide(); // Hide the login form
                        }
                        else
                        {
                            MessageBox.Show("Invalid email or password.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            RegisterationForm RegForm = new RegisterationForm();
            RegForm.Show();
            this.Hide();
            //Application.Exit();

        }
        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }
    }
}
