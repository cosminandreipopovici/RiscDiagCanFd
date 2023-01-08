using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.IO.Ports;
using TermLibrary;
using System.Threading;
using RisCanFd_Asm;

namespace RisCanFd_DebugIDE
{
    public partial class RisCanFd_DebugIDE_GUI : Form
    {
        private TermDriver termDriver;
        public RisCanFd_DebugIDE_GUI()
        { 
            TextBox.CheckForIllegalCrossThreadCalls = false;
            DataGridView.CheckForIllegalCrossThreadCalls = false;
            InitializeComponent();
            comboBox_ComPort.Items.AddRange(SerialPort.GetPortNames());
            Enable_Config_Controls();
            openFileDialog_datamemwrite_File = new OpenFileDialog
            {
                Filter = "TXT Document (*.txt)|*.txt",
                DefaultExt = ".txt",
                InitialDirectory = Directory.GetCurrentDirectory()
            };

            openFileDialog_AsmCode = new OpenFileDialog
            {
                Filter = "RVI File (*.rvi)|*.rvi",
                DefaultExt = ".rvi",
                InitialDirectory = Directory.GetCurrentDirectory()
            };
        }

        public RisCanFd_Assembler RisCanFd_Assembler
        {
            get => default;
            set
            {
            }
        }

        private void button_Refresh_Click(object sender, EventArgs e)
        {
            comboBox_ComPort.Items.Clear();
            comboBox_ComPort.Items.AddRange(SerialPort.GetPortNames());
        }

        private void Disable_Config_Controls()
        {
            button_Refresh.Enabled = false;
            button_Connect.Enabled = false;
            comboBox_ComPort.Enabled = false;
            button_Disconnect.Enabled = true;
        }

        private void Enable_Config_Controls()
        {
            button_Refresh.Enabled = true;
            button_Connect.Enabled = true;
            comboBox_ComPort.Enabled = true;
            button_Disconnect.Enabled = false;
        }
   
        private void button_Connect_Click(object sender, EventArgs e)
        {
            try
            {
                Disable_Config_Controls();
                termDriver = new TermDriver(
                    comboBox_ComPort.SelectedItem.ToString(),
                    "921600", "8", "NONE", "1", "NONE",
                    new Common.ByteReceivedEventHandler[] { Print_Byte_Hex},
                    false, false
                );
                termDriver.Connect();
                button_Connect.Text = "Connected!";
                log("Succesfully connected to " + comboBox_ComPort.SelectedItem.ToString());
            }
            catch (Exception ee)
            {
                log(ee.Message);
                Enable_Config_Controls();
            }
        }

        private void button_Disconnect_Click(object sender, EventArgs e)
        {
            try
            {
                Enable_Config_Controls();
                termDriver.Disconnect();
                termDriver = null;
                button_Connect.Text = "Connect";
                log("Succesfully disconnected from " + comboBox_ComPort.SelectedItem.ToString());
            }
            catch (Exception ee)
            {
                log(ee.Message);
                Disable_Config_Controls();
            }
        }

        public void Print_Byte_Hex(object sender, Common.ByteReceivedEventArgs args)
        {
            Console.Write((args.receivedByte.ToString("X") + " "));
        }

        //************************************************************************************************
        public static String GetTimestamp() => DateTime.Now.ToString("[yyyy/MM/dd - HH:mm:ss.fff]  ->  ");
        public static String GetTimestamp_ffn() => DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss");
        public void log(String Message)
        {
            textBox_Log.AppendText(GetTimestamp() + Message + "\r\n");
            if (textBox_Log.Lines.Length > 100)
            {
                List<string> linesList = textBox_Log.Lines.ToList();
                linesList.RemoveAt(0);
                textBox_Log.Lines = linesList.ToArray();
            }
        }
        private void button_LogClear_Click(object sender, EventArgs e) => textBox_Log.Clear();

        private void button_datamemwrite_LoadFile_Click(object sender, EventArgs e)
        {
            if (openFileDialog_datamemwrite_File.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    textBox_datamem_write.Clear();
                    StreamReader sr = new StreamReader(openFileDialog_datamemwrite_File.FileName);
                    string line;
                    while ((line = sr.ReadLine()) != null)
                    {
                        textBox_datamem_write.AppendText(line+"\r\n");
                    }
                    sr.Close();
                }
                catch (Exception ee)
                {
                    log("Error at loading Data Memory write file: "+ ee.Message);
                }
            }
        }

        private void button_datamem_Write_Click(object sender, EventArgs e)
        {
            try
            {   
                string[] DataMem_Lines = textBox_datamem_write.Lines;
                List<byte[]> memLines= new List<byte[]>();
                byte[] bufferToRecv = null;
                foreach (string line in DataMem_Lines)
                {
                    byte[] bufferToSend = new byte[8];
                    
                    if (line.Contains("#")) continue;
                    if (!line.Contains(":")) continue;
                    string[] comps=line.Split(':');
                    UInt16 addr = (UInt16)Convert.ToUInt16(comps[0], 16);
                    UInt32 data = (UInt32)Convert.ToUInt32(comps[1], 16);

                    bufferToSend[0] = 0xA2;
                    bufferToSend[1] = (byte)((addr >>  8) & 0xFF);
                    bufferToSend[2] = (byte)((addr >>  0) & 0xFF);
                    bufferToSend[3] = (byte)((data >> 24) & 0xFF);
                    bufferToSend[4] = (byte)((data >> 16) & 0xFF);
                    bufferToSend[5] = (byte)((data >>  8) & 0xFF);
                    bufferToSend[6] = (byte)((data >>  0) & 0xFF);
                    bufferToSend[7] = 0xFF;

                    memLines.Add(bufferToSend);
                }
                int prg = 0;
                termDriver.Send_Message_and_Get_Response(new byte[] { 0xB5, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB5 }, 8, 4, out _);
                Thread.Sleep(1);
                foreach (byte[] bufferToSend in memLines)
                {
                    termDriver.Send_Message_and_Get_Response(bufferToSend, 8, 4, out bufferToRecv);
                    Thread.Sleep(1);
                }
                termDriver.Send_Message_and_Get_Response(new byte[] { 0xB6, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB6 }, 8, 4, out _);
                Thread.Sleep(1);
                log("Data Memory Write performed SUCCESFULLY!");

            }
            catch (Exception ee)
            {
                log("Error at Writing to Data Memory: "+ee.Message);
            }
        }

        private void button_datamem_Read_Click(object sender, EventArgs e)
        {
            try
            {
                if (textBox_datamemread_start.Text.Equals("")) 
                    throw new ApplicationException("No Start Address for Reading Data Memory");
                if (textBox_datamemread_stop.Text.Equals(""))
                    throw new ApplicationException("No Stop Address for Reading Data Memory");
                string adr_start=textBox_datamemread_start.Text;
                string adr_stopp=textBox_datamemread_stop.Text;
                UInt16 adr_a = (UInt16)Convert.ToUInt16(adr_start, 16); 
                UInt16 adr_z = (UInt16)Convert.ToUInt16(adr_stopp, 16);
                List<byte[]> buffersToSend = new List<byte[]>();
                List<byte[]> buffersToRecv = new List<byte[]>();
                byte[] bufferToRecv=null;
                for (UInt16 adr = adr_a; adr <= adr_z; ++adr)
                {
                    byte[] bufferToSend = new byte[8];
                    bufferToSend[0] = 0xA1;
                    bufferToSend[1] = (byte)((adr >> 8) & 0xFF);
                    bufferToSend[2] = (byte)((adr >> 0) & 0xFF);
                    bufferToSend[3] = bufferToSend[4] = bufferToSend[5] = bufferToSend[6] = bufferToSend[7] = 0x00;
                    buffersToSend.Add(bufferToSend);
                }
                foreach (byte[] bufferToSend in buffersToSend)
                {
                    termDriver.Send_Message_and_Get_Response(bufferToSend, 8, 4, out bufferToRecv);
                    buffersToRecv.Add(bufferToRecv);
                    Thread.Sleep(1);
                }
                if (buffersToRecv.Count != buffersToSend.Count)
                    throw new ApplicationException("Not enough memory lines received!");
                textBox_datamem_read.Clear();
                for (UInt16 adr = adr_a; adr <= adr_z; ++adr)
                {
                    String s_addr = String.Format("{0:X4}", adr);
                    UInt32 data = 0;
                    data |= ((UInt32)buffersToRecv[adr - adr_a][0]) << 24;
                    data |= ((UInt32)buffersToRecv[adr - adr_a][1]) << 16;
                    data |= ((UInt32)buffersToRecv[adr - adr_a][2]) <<  8;
                    data |= ((UInt32)buffersToRecv[adr - adr_a][3]) <<  0;
                    String s_data = String.Format("{0:X8}",data);
                    textBox_datamem_read.AppendText(s_addr + ":" + s_data + "\r\n");
                }
                log("Data Memory Read performed SUCCESFULLY!");
            }
            catch (Exception ee)
            {
                log("Error at Reading from Data Memory: " + ee.Message);
            }
        }

        private void button_progmem_Write_Click(object sender, EventArgs e)
        {
            try
            {
                string[] ProgMem_Lines = textBox_progmem_write.Lines;
                List<byte[]> memLines = new List<byte[]>();
                byte[] bufferToRecv = null;
                foreach (string line in ProgMem_Lines)
                {
                    byte[] bufferToSend = new byte[8];

                    if (line.Contains("#")) continue;
                    if (!line.Contains(":")) continue;
                    string[] comps = line.Split(':');
                    UInt16 addr = (UInt16)Convert.ToUInt16(comps[0], 16);
                    UInt32 data = (UInt32)Convert.ToUInt32(comps[1], 16);

                    bufferToSend[0] = 0xB2;
                    bufferToSend[1] = (byte)((addr >> 8) & 0xFF);
                    bufferToSend[2] = (byte)((addr >> 0) & 0xFF);
                    bufferToSend[3] = (byte)((data >> 24) & 0xFF);
                    bufferToSend[4] = (byte)((data >> 16) & 0xFF);
                    bufferToSend[5] = (byte)((data >> 8) & 0xFF);
                    bufferToSend[6] = (byte)((data >> 0) & 0xFF);
                    bufferToSend[7] = 0xFF;

                    memLines.Add(bufferToSend);
                }
                termDriver.Send_Message_and_Get_Response(new byte[] { 0xB5, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB5 }, 8, 4, out _);
                Thread.Sleep(1);
                foreach (byte[] bufferToSend in memLines)
                {
                    termDriver.Send_Message_and_Get_Response(bufferToSend, 8, 4, out bufferToRecv);
                    Thread.Sleep(1);
                }
                termDriver.Send_Message_and_Get_Response(new byte[] { 0xB6, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB6 }, 8, 4, out _);
                Thread.Sleep(1);
                log("Program Memory Write performed SUCCESFULLY!");

            }
            catch (Exception ee)
            {
                log("Error at Writing to Program Memory: " + ee.Message);
            }
        }

        private void button_progmem_Read_Click(object sender, EventArgs e)
        {
            try
            {
                if (textBox_progmemread_start.Text.Equals(""))
                    throw new ApplicationException("No Start Address for Reading Program Memory");
                if (textBox_progmemread_stop.Text.Equals(""))
                    throw new ApplicationException("No Stop Address for Reading Program Memory");
                string adr_start = textBox_progmemread_start.Text;
                string adr_stopp = textBox_progmemread_stop.Text;
                UInt16 adr_a = (UInt16)Convert.ToUInt16(adr_start, 16);
                UInt16 adr_z = (UInt16)Convert.ToUInt16(adr_stopp, 16);
                List<byte[]> buffersToSend = new List<byte[]>();
                List<byte[]> buffersToRecv = new List<byte[]>();
                byte[] bufferToRecv = null;
                for (UInt16 adr = adr_a; adr <= adr_z; ++adr)
                {
                    byte[] bufferToSend = new byte[8];
                    bufferToSend[0] = 0xB1;
                    bufferToSend[1] = (byte)((adr >> 8) & 0xFF);
                    bufferToSend[2] = (byte)((adr >> 0) & 0xFF);
                    bufferToSend[3] = bufferToSend[4] = bufferToSend[5] = bufferToSend[6] = bufferToSend[7] = 0x00;
                    buffersToSend.Add(bufferToSend);
                }
                foreach (byte[] bufferToSend in buffersToSend)
                {
                    termDriver.Send_Message_and_Get_Response(bufferToSend, 8, 4, out bufferToRecv);
                    buffersToRecv.Add(bufferToRecv);
                    Thread.Sleep(1);
                }
                if (buffersToRecv.Count != buffersToSend.Count)
                    throw new ApplicationException("Not enough memory lines received!");
                textBox_progmem_read.Clear();
                for (UInt16 adr = adr_a; adr <= adr_z; ++adr)
                {
                    String s_addr = String.Format("{0:X4}", adr);
                    UInt32 data = 0;
                    data |= ((UInt32)buffersToRecv[adr - adr_a][0]) << 24;
                    data |= ((UInt32)buffersToRecv[adr - adr_a][1]) << 16;
                    data |= ((UInt32)buffersToRecv[adr - adr_a][2]) << 8;
                    data |= ((UInt32)buffersToRecv[adr - adr_a][3]) << 0;
                    String s_data = String.Format("{0:X8}", data);
                    textBox_progmem_read.AppendText(s_addr + ":" + s_data + "\r\n");
                }
                log("Program Memory Read performed SUCCESFULLY!");
            }
            catch (Exception ee)
            {
                log("Error at Reading from Program Memory: " + ee.Message);
            }
        }
        //************************************************************************************************
        private void button_asm2mach_Click(object sender, EventArgs e)
        {
            textBox_progmem_write.Clear();
            textBox_MachineCode.Clear();
            List<Tuple<string,string,string>> instructionsTuple=RisCanFd_Assembler.AsmCode_2_MachineCode(textBox_progmem_asmcode.Lines);
            for (int i = 0; i < instructionsTuple.Count; ++i)
            {
                textBox_progmem_write.AppendText(instructionsTuple[i].Item1+":"+instructionsTuple[i].Item2+"\r\n");
                textBox_MachineCode.AppendText(instructionsTuple[i].Item3+"\r\n");
            }
        }

        private void button_Reset_Click(object sender, EventArgs e)
        {
            try
            {
                termDriver.Send_Message_and_Get_Response(new byte[] { 0xB5, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB5 }, 8, 4, out _);
                Thread.Sleep(150);
                termDriver.Send_Message_and_Get_Response(new byte[] { 0xB6, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB5 }, 8, 4, out _);
            }
            catch (Exception ee)
            {
                log("Error at Resetting: "+ee.Message);
            }
        }

        private void button_ResetOn_Click(object sender, EventArgs e)
        {
            try
            {
                button_ResetOn.Enabled = false;
                button_ResetOff.Enabled = true;
                termDriver.Send_Message_and_Get_Response(new byte[] { 0xB5, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB5 }, 8, 4, out _);
            }
            catch (Exception ee)
            {
                log("Error at issueing Reset ON: " + ee.Message);
            }
        }

        private void button_ResetOff_Click(object sender, EventArgs e)
        {
            try
            {
                button_ResetOn.Enabled = true;
                button_ResetOff.Enabled = false;
                termDriver.Send_Message_and_Get_Response(new byte[] { 0xB6, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB5 }, 8, 4, out _);
            }
            catch (Exception ee)
            {
                log("Error at issueing Reset ON: " + ee.Message);
            }
        }

        private void button_AsmCode_LoadFile_Click(object sender, EventArgs e)
        {
            if (openFileDialog_AsmCode.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    textBox_progmem_asmcode.Clear();
                    StreamReader sr = new StreamReader(openFileDialog_AsmCode.FileName);
                    string line;
                    while ((line = sr.ReadLine()) != null)
                    {
                        textBox_progmem_asmcode.AppendText(line + "\r\n");
                    }
                    sr.Close();
                }
                catch (Exception ee)
                {
                    log("Error at loading Asm file: " + ee.Message);
                }
            }
        }

        //************************************************************************************************
    }
}
