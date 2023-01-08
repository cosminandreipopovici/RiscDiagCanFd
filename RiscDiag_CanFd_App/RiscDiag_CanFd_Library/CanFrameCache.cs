using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;

namespace RiscDiag_CanFd_Library
{
    public class CanFrameCache
    {
        private TreeView treeView;
        private TreeView copy;
        private CheckBox format;

        public CanFrameCache(CheckBox format)
        {
            this.treeView = new TreeView();
            this.format = format;
        }

        public void AddFrame(TreeNode treeNode)
        {
            if (treeView.Nodes.Count >= 1000)
            {
                copy = treeView;
                treeView = new TreeView();
                treeView.Nodes.Add(treeNode);
                if (format.Checked)
                {
                    new Thread(new ThreadStart(ExportCopyXml)).Start();
                }
                else new Thread(new ThreadStart(ExportCopyTxt)).Start();

            }
            else treeView.Nodes.Add(treeNode);
        }

        private static string GetTimestampForXmlFileName(bool isXml)
        {
            return "CanFd_Trace_" + DateTime.Now.ToString("yyyy_MM_dd__HH_mm_ss") + ((isXml==true)?".xml":".txt");
        }

        private void ExportCopyTxt() 
        {
            ExportCopyTxtExpress(copy);
        }

        public static void ExportCopyTxtExpress(TreeView treeView)
        {
            StreamWriter streamWriter = new StreamWriter(@"logs\" + GetTimestampForXmlFileName(false));
            foreach (TreeNode treeNode in treeView.Nodes)
                streamWriter.WriteLine(treeNode.Text);
            streamWriter.Flush();
            streamWriter.Close();
        }

        private void ExportCopyXml()
        {
            ExportCopyXmlExpress(copy);
        }

        public static void ExportCopyXmlExpress(TreeView treeView)
        {
            string[] separatingStrings = { " : " };
            TreeNodeCollection tnc =treeView.Nodes;
            XmlTextWriter writer = new XmlTextWriter(@"logs\" + GetTimestampForXmlFileName(true), System.Text.Encoding.UTF8);
            writer.Indentation = 4;
            writer.Formatting = Formatting.Indented;
            writer.WriteStartDocument();
            writer.WriteStartElement("CANFD_FRAMES");
            foreach (TreeNode tn in tnc)
            {
                if (tn.Nodes[1].Text.Contains(CanFrame.FRAME_TYPE_RX))
                {
                    writer.WriteStartElement("CANFD_FRAME");

                    writer.WriteStartElement("FRAME_ALL_INFO");
                    writer.WriteString(tn.Text);
                    writer.WriteEndElement();

                    writer.WriteStartElement("TIMESTAMP");
                    writer.WriteString(tn.Nodes[0].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();

                    writer.WriteStartElement("TYPE");
                    writer.WriteString(tn.Nodes[1].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();

                    writer.WriteStartElement("ID");
                    writer.WriteString(tn.Nodes[2].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();

                    writer.WriteStartElement("IDE");
                    writer.WriteString(tn.Nodes[3].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();

                    writer.WriteStartElement("FDF");
                    writer.WriteString(tn.Nodes[4].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();

                    writer.WriteStartElement("RTR");
                    writer.WriteString(tn.Nodes[5].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();

                    writer.WriteStartElement("DLC");
                    writer.WriteString(tn.Nodes[6].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();

                    writer.WriteStartElement("PAYLOAD");
                    writer.WriteString(tn.Nodes[7].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();

                    writer.WriteEndElement();
                }
                else if (tn.Text.Contains(CanFrame.FRAME_TYPE_ER))
                { 
                    writer.WriteStartElement("ERROR_INFO");

                    writer.WriteStartElement("ERROR_INFO_ALL");
                    writer.WriteString(tn.Text);
                    writer.WriteEndElement();

                    writer.WriteStartElement("ERROR_CODE");
                    writer.WriteString(tn.Nodes[0].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();


                    
                    writer.WriteStartElement("ERROR_TYPE");
                    writer.WriteStartElement("ERROR_TYPE_CODE");
                    writer.WriteString(tn.Nodes[1].Nodes[0].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();
                    writer.WriteStartElement("ERROR_TYPE_STR");
                    writer.WriteString(tn.Nodes[1].Nodes[1].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();
                    writer.WriteEndElement();

                    writer.WriteStartElement("ERROR_SUBTYPE");
                    writer.WriteStartElement("ERROR_SUBTYPE_CODE");
                    writer.WriteString(tn.Nodes[2].Nodes[0].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();
                    writer.WriteStartElement("ERROR_SUBTYPE_STR");
                    writer.WriteString(tn.Nodes[2].Nodes[1].Text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries)[1]);
                    writer.WriteEndElement();
                    writer.WriteEndElement();



                    writer.WriteEndElement();
                }
                
            }
            writer.WriteEndElement();
            writer.WriteEndDocument();
            writer.Flush();
            writer.Close();
        }


    }
}
