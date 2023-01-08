using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using RiscDiag_CanFd_Library;

namespace RiscDiag_CanFd_App
{
    public partial class GUI : Form
    {
        RiscDiag_CanFd_Driver driver;
        public GUI()
        {
            InitializeComponent();
            button_Disconnect.Enabled = false;
            button_Play.Enabled = false;
        }

        private void button_Connect_Click(object sender, EventArgs e)
        {
            try
            {
                driver = new RiscDiag_CanFd_Driver(treeView1,checkBox_Format);
                driver.Connect(textBox_ConnectInfo.Text);
                button_Connect.Enabled = false;
                button_Disconnect.Enabled = true;
            }
            catch (Exception ee) { log.AppendText("Error at Connect: "+ee.Message); }        
        }

        private void button_Disconnect_Click(object sender, EventArgs e)
        {
            try
            {
                driver.Disconnect();
                button_Disconnect.Enabled = false;
            }
            catch (Exception ee) { log.AppendText("Error at Disconnect: " + ee.Message); } 
        }

        private void button_Play_Click(object sender, EventArgs e)
        {
            driver.PlayShowing();
            button_Play.Enabled = false;
            button_Pause.Enabled = true;
        }

        private void button_Pause_Click(object sender, EventArgs e)
        {
            driver.PauseShowing();
            button_Play.Enabled = true;
            button_Pause.Enabled = false;
        }

        private void button_Clear_Click(object sender, EventArgs e)
        {
            treeView1.Nodes.Clear();
        }

        private void button_Export_Click(object sender, EventArgs e)
        {
            if(checkBox_Format.Checked)
                CanFrameCache.ExportCopyXmlExpress(treeView1);
            else
                CanFrameCache.ExportCopyTxtExpress(treeView1);
        }
    }
}
