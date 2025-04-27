namespace SWELab1
{
    partial class IMDb
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(IMDb));
            this.next = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // next
            // 
            this.next.BackColor = System.Drawing.Color.Transparent;
            this.next.BackgroundImage = global::SWELab1.Properties.Resources.black_2635366_1280;
            this.next.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.next.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.next.ForeColor = System.Drawing.Color.Transparent;
            this.next.Location = new System.Drawing.Point(294, 259);
            this.next.Name = "next";
            this.next.Size = new System.Drawing.Size(144, 73);
            this.next.TabIndex = 0;
            this.next.UseVisualStyleBackColor = false;
            this.next.Click += new System.EventHandler(this.next_Click);
            // 
            // IMDb
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackgroundImage = global::SWELab1.Properties.Resources.gametiles_com_imdb_mobile;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.ClientSize = new System.Drawing.Size(698, 532);
            this.Controls.Add(this.next);
            this.ForeColor = System.Drawing.Color.DeepPink;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "IMDb";
            this.Text = "IMDb";
            this.Load += new System.EventHandler(this.IMDb_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button next;
    }
}