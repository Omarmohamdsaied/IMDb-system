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
            this.FormClosing += Form1_FormClosing;
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
       


        }

       /* private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            conn.Dispose();
        }*/

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
                    string query = "SELECT id, role FROM users WHERE email = :email AND password = :password";

                    using (OracleCommand cmd = new OracleCommand(query, conn))
                    {
                        cmd.Parameters.Add("email", Email.Text);
                        cmd.Parameters.Add("password", textBox2.Text);

                        using (OracleDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string userId = reader["id"].ToString();
                                string role = reader["role"].ToString();

                                if (role == "user")
                                {
                                    UserForm userForm = new UserForm(userId); // Pass ID to UserForm constructor
                                    userForm.Show();
                                }
                                else if (role == "admin")
                                {
                                    AdminForm adminForm = new AdminForm(userId);
                                    adminForm.Show();
                                }

                                this.Hide();
                            }
                            else
                            {
                                MessageBox.Show("Invalid email or password.");
                            }
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
            RegForm.Owner = this;
            RegForm.Show();
            this.Hide();
           

        }
       

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
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

        private void label1_Click(object sender, EventArgs e)
        {

        }
    }
}
