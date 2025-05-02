using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SWELab1
{
    public partial class IMDb : Form
    {
        public IMDb()
        {
            this.FormClosing += IMDb_FormClosing;
            InitializeComponent();
        }

        private void next_Click(object sender, EventArgs e)
        {
            LogIn form1 = new LogIn(); // create an instance of Form1
            form1.Show();              // show Form1
            this.Hide();               // hide current form (optional: you can also use this.Close())
        }

        private void IMDb_FormClosing(object sender, FormClosingEventArgs e)
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

        private void IMDb_Load(object sender, EventArgs e)
        {

        }
    }
}
