namespace RisCanFd_DebugIDE
{
    partial class RisCanFd_DebugIDE_GUI
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
            if (termDriver != null) button_Disconnect_Click(null, null);
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
            this.groupBox_PortConfigurations = new System.Windows.Forms.GroupBox();
            this.groupBox_ConDiscon = new System.Windows.Forms.GroupBox();
            this.button_Disconnect = new System.Windows.Forms.Button();
            this.button_Connect = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.comboBox_ComPort = new System.Windows.Forms.ComboBox();
            this.button_Refresh = new System.Windows.Forms.Button();
            this.groupBox_Log = new System.Windows.Forms.GroupBox();
            this.button_LogClear = new System.Windows.Forms.Button();
            this.textBox_Log = new System.Windows.Forms.TextBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.button_datamemwrite_LoadFile = new System.Windows.Forms.Button();
            this.button_datamem_Write = new System.Windows.Forms.Button();
            this.textBox_datamem_write = new System.Windows.Forms.TextBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.button_datamem_Read = new System.Windows.Forms.Button();
            this.textBox_datamemread_stop = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.textBox_datamemread_start = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.textBox_datamem_read = new System.Windows.Forms.TextBox();
            this.openFileDialog_datamemwrite_File = new System.Windows.Forms.OpenFileDialog();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.groupBox9 = new System.Windows.Forms.GroupBox();
            this.textBox_MachineCode = new System.Windows.Forms.TextBox();
            this.groupBox8 = new System.Windows.Forms.GroupBox();
            this.button_AsmCode_LoadFile = new System.Windows.Forms.Button();
            this.textBox_progmem_asmcode = new System.Windows.Forms.TextBox();
            this.button_asm2mach = new System.Windows.Forms.Button();
            this.groupBox6 = new System.Windows.Forms.GroupBox();
            this.button_progmem_Write = new System.Windows.Forms.Button();
            this.textBox_progmem_write = new System.Windows.Forms.TextBox();
            this.groupBox7 = new System.Windows.Forms.GroupBox();
            this.button_progmem_Read = new System.Windows.Forms.Button();
            this.textBox_progmemread_stop = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.textBox_progmemread_start = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.textBox_progmem_read = new System.Windows.Forms.TextBox();
            this.groupBox10 = new System.Windows.Forms.GroupBox();
            this.button_ResetOff = new System.Windows.Forms.Button();
            this.button_ResetOn = new System.Windows.Forms.Button();
            this.button_Reset = new System.Windows.Forms.Button();
            this.openFileDialog_AsmCode = new System.Windows.Forms.OpenFileDialog();
            this.groupBox_PortConfigurations.SuspendLayout();
            this.groupBox_ConDiscon.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox_Log.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox5.SuspendLayout();
            this.groupBox9.SuspendLayout();
            this.groupBox8.SuspendLayout();
            this.groupBox6.SuspendLayout();
            this.groupBox7.SuspendLayout();
            this.groupBox10.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox_PortConfigurations
            // 
            this.groupBox_PortConfigurations.Controls.Add(this.groupBox_ConDiscon);
            this.groupBox_PortConfigurations.Controls.Add(this.groupBox1);
            this.groupBox_PortConfigurations.Location = new System.Drawing.Point(12, 12);
            this.groupBox_PortConfigurations.Name = "groupBox_PortConfigurations";
            this.groupBox_PortConfigurations.Size = new System.Drawing.Size(407, 77);
            this.groupBox_PortConfigurations.TabIndex = 5;
            this.groupBox_PortConfigurations.TabStop = false;
            this.groupBox_PortConfigurations.Text = "COM Port Configuration";
            // 
            // groupBox_ConDiscon
            // 
            this.groupBox_ConDiscon.Controls.Add(this.button_Disconnect);
            this.groupBox_ConDiscon.Controls.Add(this.button_Connect);
            this.groupBox_ConDiscon.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox_ConDiscon.Location = new System.Drawing.Point(183, 18);
            this.groupBox_ConDiscon.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox_ConDiscon.Name = "groupBox_ConDiscon";
            this.groupBox_ConDiscon.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox_ConDiscon.Size = new System.Drawing.Size(219, 49);
            this.groupBox_ConDiscon.TabIndex = 16;
            this.groupBox_ConDiscon.TabStop = false;
            this.groupBox_ConDiscon.Text = "Connect / Disconnect";
            // 
            // button_Disconnect
            // 
            this.button_Disconnect.BackColor = System.Drawing.Color.Pink;
            this.button_Disconnect.Enabled = false;
            this.button_Disconnect.Location = new System.Drawing.Point(85, 15);
            this.button_Disconnect.Margin = new System.Windows.Forms.Padding(2);
            this.button_Disconnect.Name = "button_Disconnect";
            this.button_Disconnect.Size = new System.Drawing.Size(125, 25);
            this.button_Disconnect.TabIndex = 11;
            this.button_Disconnect.Text = "Disconnect";
            this.button_Disconnect.UseVisualStyleBackColor = false;
            this.button_Disconnect.Click += new System.EventHandler(this.button_Disconnect_Click);
            // 
            // button_Connect
            // 
            this.button_Connect.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.button_Connect.Location = new System.Drawing.Point(4, 15);
            this.button_Connect.Margin = new System.Windows.Forms.Padding(2);
            this.button_Connect.Name = "button_Connect";
            this.button_Connect.Size = new System.Drawing.Size(77, 25);
            this.button_Connect.TabIndex = 10;
            this.button_Connect.Text = "Connect";
            this.button_Connect.UseVisualStyleBackColor = false;
            this.button_Connect.Click += new System.EventHandler(this.button_Connect_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.comboBox_ComPort);
            this.groupBox1.Controls.Add(this.button_Refresh);
            this.groupBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox1.Location = new System.Drawing.Point(5, 18);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox1.Size = new System.Drawing.Size(174, 49);
            this.groupBox1.TabIndex = 10;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "COM Port";
            // 
            // comboBox_ComPort
            // 
            this.comboBox_ComPort.FormattingEnabled = true;
            this.comboBox_ComPort.Location = new System.Drawing.Point(6, 18);
            this.comboBox_ComPort.Name = "comboBox_ComPort";
            this.comboBox_ComPort.Size = new System.Drawing.Size(81, 21);
            this.comboBox_ComPort.TabIndex = 17;
            // 
            // button_Refresh
            // 
            this.button_Refresh.BackColor = System.Drawing.Color.PapayaWhip;
            this.button_Refresh.Location = new System.Drawing.Point(92, 15);
            this.button_Refresh.Margin = new System.Windows.Forms.Padding(2);
            this.button_Refresh.Name = "button_Refresh";
            this.button_Refresh.Size = new System.Drawing.Size(77, 25);
            this.button_Refresh.TabIndex = 9;
            this.button_Refresh.Text = "Refresh";
            this.button_Refresh.UseVisualStyleBackColor = false;
            this.button_Refresh.Click += new System.EventHandler(this.button_Refresh_Click);
            // 
            // groupBox_Log
            // 
            this.groupBox_Log.Controls.Add(this.button_LogClear);
            this.groupBox_Log.Controls.Add(this.textBox_Log);
            this.groupBox_Log.Location = new System.Drawing.Point(12, 823);
            this.groupBox_Log.Name = "groupBox_Log";
            this.groupBox_Log.Size = new System.Drawing.Size(1816, 131);
            this.groupBox_Log.TabIndex = 6;
            this.groupBox_Log.TabStop = false;
            this.groupBox_Log.Text = "Log";
            // 
            // button_LogClear
            // 
            this.button_LogClear.Location = new System.Drawing.Point(1737, 104);
            this.button_LogClear.Margin = new System.Windows.Forms.Padding(2);
            this.button_LogClear.Name = "button_LogClear";
            this.button_LogClear.Size = new System.Drawing.Size(74, 22);
            this.button_LogClear.TabIndex = 3;
            this.button_LogClear.Text = "Clear Log";
            this.button_LogClear.UseVisualStyleBackColor = true;
            // 
            // textBox_Log
            // 
            this.textBox_Log.BackColor = System.Drawing.Color.White;
            this.textBox_Log.Location = new System.Drawing.Point(11, 18);
            this.textBox_Log.Margin = new System.Windows.Forms.Padding(2);
            this.textBox_Log.Multiline = true;
            this.textBox_Log.Name = "textBox_Log";
            this.textBox_Log.ReadOnly = true;
            this.textBox_Log.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox_Log.Size = new System.Drawing.Size(1800, 83);
            this.textBox_Log.TabIndex = 1;
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.groupBox4);
            this.groupBox2.Controls.Add(this.groupBox3);
            this.groupBox2.Location = new System.Drawing.Point(12, 95);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(559, 722);
            this.groupBox2.TabIndex = 7;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Data Memory";
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.button_datamemwrite_LoadFile);
            this.groupBox4.Controls.Add(this.button_datamem_Write);
            this.groupBox4.Controls.Add(this.textBox_datamem_write);
            this.groupBox4.Location = new System.Drawing.Point(282, 19);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(265, 682);
            this.groupBox4.TabIndex = 1;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "Write";
            // 
            // button_datamemwrite_LoadFile
            // 
            this.button_datamemwrite_LoadFile.Location = new System.Drawing.Point(85, 653);
            this.button_datamemwrite_LoadFile.Name = "button_datamemwrite_LoadFile";
            this.button_datamemwrite_LoadFile.Size = new System.Drawing.Size(94, 23);
            this.button_datamemwrite_LoadFile.TabIndex = 11;
            this.button_datamemwrite_LoadFile.Text = "Load File";
            this.button_datamemwrite_LoadFile.UseVisualStyleBackColor = true;
            this.button_datamemwrite_LoadFile.Click += new System.EventHandler(this.button_datamemwrite_LoadFile_Click);
            // 
            // button_datamem_Write
            // 
            this.button_datamem_Write.Location = new System.Drawing.Point(185, 653);
            this.button_datamem_Write.Name = "button_datamem_Write";
            this.button_datamem_Write.Size = new System.Drawing.Size(75, 23);
            this.button_datamem_Write.TabIndex = 6;
            this.button_datamem_Write.Text = "Write";
            this.button_datamem_Write.UseVisualStyleBackColor = true;
            this.button_datamem_Write.Click += new System.EventHandler(this.button_datamem_Write_Click);
            // 
            // textBox_datamem_write
            // 
            this.textBox_datamem_write.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox_datamem_write.Location = new System.Drawing.Point(9, 19);
            this.textBox_datamem_write.Multiline = true;
            this.textBox_datamem_write.Name = "textBox_datamem_write";
            this.textBox_datamem_write.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox_datamem_write.Size = new System.Drawing.Size(247, 618);
            this.textBox_datamem_write.TabIndex = 6;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.button_datamem_Read);
            this.groupBox3.Controls.Add(this.textBox_datamemread_stop);
            this.groupBox3.Controls.Add(this.label2);
            this.groupBox3.Controls.Add(this.textBox_datamemread_start);
            this.groupBox3.Controls.Add(this.label1);
            this.groupBox3.Controls.Add(this.textBox_datamem_read);
            this.groupBox3.Location = new System.Drawing.Point(11, 19);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(265, 682);
            this.groupBox3.TabIndex = 0;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Read";
            // 
            // button_datamem_Read
            // 
            this.button_datamem_Read.Location = new System.Drawing.Point(176, 653);
            this.button_datamem_Read.Name = "button_datamem_Read";
            this.button_datamem_Read.Size = new System.Drawing.Size(75, 23);
            this.button_datamem_Read.TabIndex = 5;
            this.button_datamem_Read.Text = "Read";
            this.button_datamem_Read.UseVisualStyleBackColor = true;
            this.button_datamem_Read.Click += new System.EventHandler(this.button_datamem_Read_Click);
            // 
            // textBox_datamemread_stop
            // 
            this.textBox_datamemread_stop.Location = new System.Drawing.Point(84, 656);
            this.textBox_datamemread_stop.Name = "textBox_datamemread_stop";
            this.textBox_datamemread_stop.Size = new System.Drawing.Size(67, 20);
            this.textBox_datamemread_stop.TabIndex = 4;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(81, 640);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(70, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Stop Address";
            // 
            // textBox_datamemread_start
            // 
            this.textBox_datamemread_start.Location = new System.Drawing.Point(7, 656);
            this.textBox_datamemread_start.Name = "textBox_datamemread_start";
            this.textBox_datamemread_start.Size = new System.Drawing.Size(67, 20);
            this.textBox_datamemread_start.TabIndex = 2;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(4, 640);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(70, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Start Address";
            // 
            // textBox_datamem_read
            // 
            this.textBox_datamem_read.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox_datamem_read.Location = new System.Drawing.Point(6, 19);
            this.textBox_datamem_read.Multiline = true;
            this.textBox_datamem_read.Name = "textBox_datamem_read";
            this.textBox_datamem_read.ReadOnly = true;
            this.textBox_datamem_read.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox_datamem_read.Size = new System.Drawing.Size(247, 618);
            this.textBox_datamem_read.TabIndex = 0;
            // 
            // openFileDialog_datamemwrite_File
            // 
            this.openFileDialog_datamemwrite_File.FileName = "file.txt";
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.groupBox9);
            this.groupBox5.Controls.Add(this.groupBox8);
            this.groupBox5.Controls.Add(this.groupBox6);
            this.groupBox5.Controls.Add(this.groupBox7);
            this.groupBox5.Location = new System.Drawing.Point(577, 95);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(1251, 722);
            this.groupBox5.TabIndex = 8;
            this.groupBox5.TabStop = false;
            this.groupBox5.Text = "Program Memory";
            // 
            // groupBox9
            // 
            this.groupBox9.Controls.Add(this.textBox_MachineCode);
            this.groupBox9.Location = new System.Drawing.Point(933, 19);
            this.groupBox9.Name = "groupBox9";
            this.groupBox9.Size = new System.Drawing.Size(312, 682);
            this.groupBox9.TabIndex = 13;
            this.groupBox9.TabStop = false;
            this.groupBox9.Text = "Machine Code";
            // 
            // textBox_MachineCode
            // 
            this.textBox_MachineCode.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox_MachineCode.Location = new System.Drawing.Point(9, 19);
            this.textBox_MachineCode.Multiline = true;
            this.textBox_MachineCode.Name = "textBox_MachineCode";
            this.textBox_MachineCode.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox_MachineCode.Size = new System.Drawing.Size(293, 618);
            this.textBox_MachineCode.TabIndex = 6;
            // 
            // groupBox8
            // 
            this.groupBox8.Controls.Add(this.button_AsmCode_LoadFile);
            this.groupBox8.Controls.Add(this.textBox_progmem_asmcode);
            this.groupBox8.Controls.Add(this.button_asm2mach);
            this.groupBox8.Location = new System.Drawing.Point(553, 19);
            this.groupBox8.Name = "groupBox8";
            this.groupBox8.Size = new System.Drawing.Size(374, 682);
            this.groupBox8.TabIndex = 12;
            this.groupBox8.TabStop = false;
            this.groupBox8.Text = "ASM Code";
            // 
            // button_AsmCode_LoadFile
            // 
            this.button_AsmCode_LoadFile.Location = new System.Drawing.Point(174, 653);
            this.button_AsmCode_LoadFile.Name = "button_AsmCode_LoadFile";
            this.button_AsmCode_LoadFile.Size = new System.Drawing.Size(94, 23);
            this.button_AsmCode_LoadFile.TabIndex = 12;
            this.button_AsmCode_LoadFile.Text = "Load File";
            this.button_AsmCode_LoadFile.UseVisualStyleBackColor = true;
            this.button_AsmCode_LoadFile.Click += new System.EventHandler(this.button_AsmCode_LoadFile_Click);
            // 
            // textBox_progmem_asmcode
            // 
            this.textBox_progmem_asmcode.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox_progmem_asmcode.Location = new System.Drawing.Point(9, 19);
            this.textBox_progmem_asmcode.Multiline = true;
            this.textBox_progmem_asmcode.Name = "textBox_progmem_asmcode";
            this.textBox_progmem_asmcode.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox_progmem_asmcode.Size = new System.Drawing.Size(359, 618);
            this.textBox_progmem_asmcode.TabIndex = 6;
            // 
            // button_asm2mach
            // 
            this.button_asm2mach.Location = new System.Drawing.Point(274, 653);
            this.button_asm2mach.Name = "button_asm2mach";
            this.button_asm2mach.Size = new System.Drawing.Size(94, 23);
            this.button_asm2mach.TabIndex = 11;
            this.button_asm2mach.Text = "Assemble Code";
            this.button_asm2mach.UseVisualStyleBackColor = true;
            this.button_asm2mach.Click += new System.EventHandler(this.button_asm2mach_Click);
            // 
            // groupBox6
            // 
            this.groupBox6.Controls.Add(this.button_progmem_Write);
            this.groupBox6.Controls.Add(this.textBox_progmem_write);
            this.groupBox6.Location = new System.Drawing.Point(282, 19);
            this.groupBox6.Name = "groupBox6";
            this.groupBox6.Size = new System.Drawing.Size(265, 682);
            this.groupBox6.TabIndex = 1;
            this.groupBox6.TabStop = false;
            this.groupBox6.Text = "Write";
            // 
            // button_progmem_Write
            // 
            this.button_progmem_Write.Location = new System.Drawing.Point(181, 653);
            this.button_progmem_Write.Name = "button_progmem_Write";
            this.button_progmem_Write.Size = new System.Drawing.Size(75, 23);
            this.button_progmem_Write.TabIndex = 6;
            this.button_progmem_Write.Text = "Write";
            this.button_progmem_Write.UseVisualStyleBackColor = true;
            this.button_progmem_Write.Click += new System.EventHandler(this.button_progmem_Write_Click);
            // 
            // textBox_progmem_write
            // 
            this.textBox_progmem_write.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox_progmem_write.Location = new System.Drawing.Point(9, 19);
            this.textBox_progmem_write.Multiline = true;
            this.textBox_progmem_write.Name = "textBox_progmem_write";
            this.textBox_progmem_write.ReadOnly = true;
            this.textBox_progmem_write.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox_progmem_write.Size = new System.Drawing.Size(247, 618);
            this.textBox_progmem_write.TabIndex = 6;
            // 
            // groupBox7
            // 
            this.groupBox7.Controls.Add(this.button_progmem_Read);
            this.groupBox7.Controls.Add(this.textBox_progmemread_stop);
            this.groupBox7.Controls.Add(this.label3);
            this.groupBox7.Controls.Add(this.textBox_progmemread_start);
            this.groupBox7.Controls.Add(this.label4);
            this.groupBox7.Controls.Add(this.textBox_progmem_read);
            this.groupBox7.Location = new System.Drawing.Point(11, 19);
            this.groupBox7.Name = "groupBox7";
            this.groupBox7.Size = new System.Drawing.Size(265, 682);
            this.groupBox7.TabIndex = 0;
            this.groupBox7.TabStop = false;
            this.groupBox7.Text = "Read";
            // 
            // button_progmem_Read
            // 
            this.button_progmem_Read.Location = new System.Drawing.Point(178, 653);
            this.button_progmem_Read.Name = "button_progmem_Read";
            this.button_progmem_Read.Size = new System.Drawing.Size(75, 23);
            this.button_progmem_Read.TabIndex = 5;
            this.button_progmem_Read.Text = "Read";
            this.button_progmem_Read.UseVisualStyleBackColor = true;
            this.button_progmem_Read.Click += new System.EventHandler(this.button_progmem_Read_Click);
            // 
            // textBox_progmemread_stop
            // 
            this.textBox_progmemread_stop.Location = new System.Drawing.Point(86, 656);
            this.textBox_progmemread_stop.Name = "textBox_progmemread_stop";
            this.textBox_progmemread_stop.Size = new System.Drawing.Size(67, 20);
            this.textBox_progmemread_stop.TabIndex = 4;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(83, 640);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(70, 13);
            this.label3.TabIndex = 3;
            this.label3.Text = "Stop Address";
            // 
            // textBox_progmemread_start
            // 
            this.textBox_progmemread_start.Location = new System.Drawing.Point(9, 656);
            this.textBox_progmemread_start.Name = "textBox_progmemread_start";
            this.textBox_progmemread_start.Size = new System.Drawing.Size(67, 20);
            this.textBox_progmemread_start.TabIndex = 2;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(6, 640);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(70, 13);
            this.label4.TabIndex = 1;
            this.label4.Text = "Start Address";
            // 
            // textBox_progmem_read
            // 
            this.textBox_progmem_read.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox_progmem_read.Location = new System.Drawing.Point(6, 19);
            this.textBox_progmem_read.Multiline = true;
            this.textBox_progmem_read.Name = "textBox_progmem_read";
            this.textBox_progmem_read.ReadOnly = true;
            this.textBox_progmem_read.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox_progmem_read.Size = new System.Drawing.Size(247, 618);
            this.textBox_progmem_read.TabIndex = 0;
            // 
            // groupBox10
            // 
            this.groupBox10.Controls.Add(this.button_ResetOff);
            this.groupBox10.Controls.Add(this.button_ResetOn);
            this.groupBox10.Controls.Add(this.button_Reset);
            this.groupBox10.Location = new System.Drawing.Point(425, 12);
            this.groupBox10.Name = "groupBox10";
            this.groupBox10.Size = new System.Drawing.Size(146, 77);
            this.groupBox10.TabIndex = 9;
            this.groupBox10.TabStop = false;
            this.groupBox10.Text = "Reset";
            // 
            // button_ResetOff
            // 
            this.button_ResetOff.Enabled = false;
            this.button_ResetOff.Location = new System.Drawing.Point(74, 47);
            this.button_ResetOff.Name = "button_ResetOff";
            this.button_ResetOff.Size = new System.Drawing.Size(66, 23);
            this.button_ResetOff.TabIndex = 2;
            this.button_ResetOff.Text = "Reset OFF";
            this.button_ResetOff.UseVisualStyleBackColor = true;
            this.button_ResetOff.Click += new System.EventHandler(this.button_ResetOff_Click);
            // 
            // button_ResetOn
            // 
            this.button_ResetOn.Location = new System.Drawing.Point(6, 47);
            this.button_ResetOn.Name = "button_ResetOn";
            this.button_ResetOn.Size = new System.Drawing.Size(62, 23);
            this.button_ResetOn.TabIndex = 1;
            this.button_ResetOn.Text = "Reset ON";
            this.button_ResetOn.UseVisualStyleBackColor = true;
            this.button_ResetOn.Click += new System.EventHandler(this.button_ResetOn_Click);
            // 
            // button_Reset
            // 
            this.button_Reset.Location = new System.Drawing.Point(6, 18);
            this.button_Reset.Name = "button_Reset";
            this.button_Reset.Size = new System.Drawing.Size(134, 23);
            this.button_Reset.TabIndex = 0;
            this.button_Reset.Text = "Reset";
            this.button_Reset.UseVisualStyleBackColor = true;
            this.button_Reset.Click += new System.EventHandler(this.button_Reset_Click);
            // 
            // openFileDialog_AsmCode
            // 
            this.openFileDialog_AsmCode.FileName = "openFileDialog1";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1834, 961);
            this.Controls.Add(this.groupBox10);
            this.Controls.Add(this.groupBox5);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox_Log);
            this.Controls.Add(this.groupBox_PortConfigurations);
            this.Name = "Form1";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "RisCanFd_DebugIDE";
            this.groupBox_PortConfigurations.ResumeLayout(false);
            this.groupBox_ConDiscon.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.groupBox_Log.ResumeLayout(false);
            this.groupBox_Log.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox5.ResumeLayout(false);
            this.groupBox9.ResumeLayout(false);
            this.groupBox9.PerformLayout();
            this.groupBox8.ResumeLayout(false);
            this.groupBox8.PerformLayout();
            this.groupBox6.ResumeLayout(false);
            this.groupBox6.PerformLayout();
            this.groupBox7.ResumeLayout(false);
            this.groupBox7.PerformLayout();
            this.groupBox10.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox_PortConfigurations;
        private System.Windows.Forms.GroupBox groupBox_ConDiscon;
        private System.Windows.Forms.Button button_Disconnect;
        private System.Windows.Forms.Button button_Connect;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.ComboBox comboBox_ComPort;
        private System.Windows.Forms.Button button_Refresh;
        private System.Windows.Forms.GroupBox groupBox_Log;
        private System.Windows.Forms.Button button_LogClear;
        private System.Windows.Forms.TextBox textBox_Log;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.Button button_datamem_Write;
        private System.Windows.Forms.TextBox textBox_datamem_write;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Button button_datamem_Read;
        private System.Windows.Forms.TextBox textBox_datamem_read;
        private System.Windows.Forms.Button button_datamemwrite_LoadFile;
        private System.Windows.Forms.OpenFileDialog openFileDialog_datamemwrite_File;
        private System.Windows.Forms.TextBox textBox_datamemread_stop;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBox_datamemread_start;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.GroupBox groupBox5;
        private System.Windows.Forms.GroupBox groupBox8;
        private System.Windows.Forms.TextBox textBox_progmem_asmcode;
        private System.Windows.Forms.GroupBox groupBox6;
        private System.Windows.Forms.Button button_asm2mach;
        private System.Windows.Forms.Button button_progmem_Write;
        private System.Windows.Forms.TextBox textBox_progmem_write;
        private System.Windows.Forms.GroupBox groupBox7;
        private System.Windows.Forms.Button button_progmem_Read;
        private System.Windows.Forms.TextBox textBox_progmemread_stop;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox textBox_progmemread_start;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox textBox_progmem_read;
        private System.Windows.Forms.GroupBox groupBox9;
        private System.Windows.Forms.TextBox textBox_MachineCode;
        private System.Windows.Forms.GroupBox groupBox10;
        private System.Windows.Forms.Button button_ResetOff;
        private System.Windows.Forms.Button button_ResetOn;
        private System.Windows.Forms.Button button_Reset;
        private System.Windows.Forms.OpenFileDialog openFileDialog_AsmCode;
        private System.Windows.Forms.Button button_AsmCode_LoadFile;
    }
}

