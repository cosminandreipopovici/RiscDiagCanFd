using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RisCanFd_Asm
{
    public class RisCanFd_Assembler
    {

        private static List<string> supported_instructions=new List<string>()
        {
            "add","sub",
            "and","or","xor",
            "sll","srl",

            "addi",
            "lw",

            "sw",

            "beq",

            "cfd_swrst",
            "cfd_sndbr",
            "cfd_smden",
            "cfd_sfmid",
            "cfd_ststp",
            "cfd_sbyts",
            "cfd_ssend",
            "cfd_enbrx",
            "cdf_disbl"
        };

        private static Dictionary<string, string> R_Type_Specifics = new Dictionary<string, string>()
        {
            {"add","0000000_000_0110011"},
            {"sub","0100000_000_0110011"},

            {"and","0000000_111_0110011"},
            {"or" ,"0000000_110_0110011"},
            {"xor","0000000_100_0110011"},

            {"sll","0000000_001_0110011"},
            {"srl","0000000_101_0110011"},

            {"cfd_swrst","0000001_000_1111000"},
            {"cfd_sndbr","0000010_000_1111000"},
            {"cfd_smden","0000011_000_1111000"},
            {"cfd_sfmid","0000100_000_1111000"},
            {"cfd_ststp","0000101_000_1111000"},
            {"cfd_sbyts","0000110_000_1111000"},
            {"cfd_ssend","0000111_000_1111000"},
            {"cfd_enbrx","0001000_000_1111000"},
            {"cdf_disbl","1111111_000_1111000"},

        };

        private static Dictionary<string, string> I_Type_Specifics = new Dictionary<string, string>()
        {
            {"addi","000_0010011"},
            {"lw"  ,"010_0000011"},
        };

        private static Dictionary<string, string> S_Type_Specifics = new Dictionary<string, string>()
        {
            {"sw"  ,"010_0100011"},
        };

        private static Dictionary<string, string> B_Type_Specifics = new Dictionary<string, string>()
        {
            {"beq"  ,"000_1100011"},
        };

        private static string Num2BitString(Byte byt, int finalLength)
        {
            const int FULL = 8;
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < FULL; ++i)
            {
                if (((byt >> (FULL - i - 1)) & 1) == 1) sb.Append('1');
                else sb.Append('0');
            }

            string res = sb.ToString();
            res = res.Remove(0, FULL - finalLength);
            return res;
        }

        private static string Num2BitString(UInt16 byt, int finalLength)
        {
            const int FULL = 16;
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < FULL; ++i)
            {
                if (((byt >> (FULL - i - 1)) & 1) == 1) sb.Append('1');
                else sb.Append('0');
            }

            string res = sb.ToString();
            res = res.Remove(0, FULL - finalLength);
            return res;
        }

        private static string FourBits2HexDigit(string fourBits)
        {
            switch (fourBits)
            {
                case "0000": return "0";
                case "0001": return "1";
                case "0010": return "2";
                case "0011": return "3";
                case "0100": return "4";
                case "0101": return "5";
                case "0110": return "6";
                case "0111": return "7";
                case "1000": return "8";
                case "1001": return "9";
                case "1010": return "A";
                case "1011": return "B";
                case "1100": return "C";
                case "1101": return "D";
                case "1110": return "E";
                case "1111": return "F";
                default:     return "" ;
            }
        }

        private static string ThirtyTwoBits2EightHexDigits(string instr)
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 8; ++i)
            {
                sb.Append(FourBits2HexDigit(instr.Substring(4*i,4)));
            }
            return sb.ToString();
        }

        private static string StartSpacesRemover(string str)
        {
            string s = str;
            if(s.StartsWith(" "))
            {
                while (s.StartsWith(" "))
                {
                    s = s.Remove(0, 1);
                }
            }
            return s;
        }

        public static List<Tuple<string,string,string>> AsmCode_2_MachineCode(string[] lines)
        {
            List<string> interm = new List<string>();
            List<Tuple<string, string, string>> result= new List<Tuple<string, string, string>>();
            int i = 0;
            while (i <= lines.Length-1)
            {
                string line = lines[i];
                //line = line.Replace("\t", "");

                line=StartSpacesRemover(line);

                if (line.Contains("#"))
                {
                    i += 1;
                    continue;
                }
                else if (line.Equals("") || line.Equals(" "))
                {
                    i += 1;
                    continue;
                }
                else if (line.Contains(":"))
                {
                    string next_instr = lines[i + 1];
                    next_instr = StartSpacesRemover(next_instr);
                    interm.Add(line + next_instr);
                    i += 2;
                }
                else
                {
                    interm.Add(line);
                    i += 1;
                }
            }

            Dictionary<string, int> labels = new Dictionary<string, int>();
            Dictionary<int,string> instructions_raw = new Dictionary<int,string>();

            for (i = 0; i < interm.Count; ++i)
            {
                if (interm[i].Contains(":"))
                {
                    string[] instr_comp_fields = interm[i].Split(':');
                    string label = instr_comp_fields[0];
                    if (labels.ContainsKey(label)) throw new ApplicationException("Label " + label + " already exists!");
                    labels.Add(label, i);
                    instructions_raw.Add(i, instr_comp_fields[1]);
                }
                else
                {
                    instructions_raw.Add(i, interm[i]);
                }
            }

            for (i = 0; i < instructions_raw.Count; ++i)
            {
                string address = String.Format("{0:X4}", instructions_raw.ElementAt(i).Key);
                string instr_raw = instructions_raw.ElementAt(i).Value;

                Console.WriteLine(address + ":" + instr_raw);

                string[] instr_fields = instr_raw.Split(' ');
                string type=instr_fields[0];

                string field_1 = instr_fields[1];
                string field_2 = instr_fields[2];
                string field_3 = instr_fields[3];

                switch (type)
                {
                    case "add":
                    case "sub":
                    case "and":
                    case "or":
                    case "xor":
                    case "sll":
                    case "srl":

                    case "cfd_swrst":
                    case "cfd_sndbr":
                    case "cfd_smden":
                    case "cfd_sfmid":
                    case "cfd_ststp":
                    case "cfd_sbyts":
                    case "cfd_ssend":
                    case "cfd_enbrx":
                    case "cdf_disbl":
                        if (!field_1.Contains("$")) throw new ApplicationException("Rd  operand of instruction " + address + " is in invalid format");
                        if (!field_2.Contains("$")) throw new ApplicationException("Rs1 operand of instruction " + address + " is in invalid format");
                        if (!field_3.Contains("$")) throw new ApplicationException("Rs2 operand of instruction " + address + " is in invalid format");
                        Byte R_u_Rd = Convert.ToByte(field_1.Replace("$", "").Replace(",",""));
                        Byte R_u_R1 = Convert.ToByte(field_2.Replace("$", "").Replace(",",""));
                        Byte R_u_R2 = Convert.ToByte(field_3.Replace("$", ""));
                        if(R_u_Rd>31 || R_u_R1> 31 || R_u_R2 > 31) throw new ApplicationException("One of the operand's register number of instruction " + address + " exceeds 31");
                        string R_Rd = Num2BitString(R_u_Rd, 5);
                        string R_R1 = Num2BitString(R_u_R1, 5);
                        string R_R2 = Num2BitString(R_u_R2, 5);

                        string[] R_fields = R_Type_Specifics[type].Split('_');
                        string R_func7 = R_fields[0];
                        string R_func3 = R_fields[1];
                        string R_opcod = R_fields[2];

                        StringBuilder R_sb = new StringBuilder();
                        R_sb.Append(R_func7);
                        R_sb.Append(R_R2);
                        R_sb.Append(R_R1);
                        R_sb.Append(R_func3);
                        R_sb.Append(R_Rd);
                        R_sb.Append(R_opcod);

                        string R_instr_bin=R_sb.ToString();
                        Console.WriteLine(String.Format("Address {0:X4}, {1} , length={2}",i,type,R_instr_bin.Length));
                        string R_instr_hex=ThirtyTwoBits2EightHexDigits(R_instr_bin);

                        Tuple<string, string, string> R_instr_tuple = Tuple.Create(address, R_instr_hex, R_instr_bin);
                        result.Add(R_instr_tuple);
                        break;
                    case "addi":
                    case "lw":
                        if (!field_1.Contains("$")) throw new ApplicationException("Rd  operand of instruction " + address + " is in invalid format");
                        if (!field_2.Contains("$")) throw new ApplicationException("Rs1 operand of instruction " + address + " is in invalid format");
                        Byte I_u_Rd = Convert.ToByte(field_1.Replace("$", "").Replace(",", ""));
                        Byte I_u_R1 = Convert.ToByte(field_2.Replace("$", "").Replace(",", ""));
                        Int16 I_i_imm = Convert.ToInt16(field_3);
                        UInt16 I_imm = 0;
                        if (I_i_imm >= 0) I_imm = (UInt16)I_i_imm;
                        else I_imm = (UInt16)(((UInt16)(1 << 12) - (UInt16)(0 - I_i_imm)));
                        string I_s_imm = Num2BitString(I_imm, 12);
                        string I_Rd = Num2BitString(I_u_Rd, 5);
                        string I_R1 = Num2BitString(I_u_R1, 5);

                        string[] I_fields = I_Type_Specifics[type].Split('_');

                        string I_func3=I_fields[0];
                        string I_opcod=I_fields[1];

                        StringBuilder I_sb=new StringBuilder();
                        I_sb.Append(I_s_imm);
                        I_sb.Append(I_R1);
                        I_sb.Append(I_func3);
                        I_sb.Append(I_Rd);
                        I_sb.Append(I_opcod);

                        string I_instr_bin=I_sb.ToString();
                        Console.WriteLine(String.Format("Address {0:X4}, {1} , length={2}", i, type, I_instr_bin.Length));
                        string I_instr_hex=ThirtyTwoBits2EightHexDigits(I_instr_bin);

                        Tuple<string, string, string> I_instr_tuple = Tuple.Create(address, I_instr_hex, I_instr_bin);
                        result.Add(I_instr_tuple);
                        break;
                    case "sw":
                        if (!field_1.Contains("$")) throw new ApplicationException("Rs1  operand of instruction " + address + " is in invalid format");
                        if (!field_2.Contains("$")) throw new ApplicationException("Rs2 operand of instruction " + address + " is in invalid format");
                        Byte S_u_R1 = Convert.ToByte(field_1.Replace("$", "").Replace(",", ""));
                        Byte S_u_R2 = Convert.ToByte(field_2.Replace("$", "").Replace(",", ""));

                        Int16 S_i_imm = Convert.ToInt16(field_3);
                        UInt16 S_imm = 0;
                        if (S_i_imm >= 0) S_imm = (UInt16)S_i_imm;
                        else S_imm = (UInt16)(((UInt16)(1 << 12) - (UInt16)(0 - S_i_imm)));
                        string S_s_imm = Num2BitString(S_imm, 12);
                        string S_R2 = Num2BitString(S_u_R2, 5);
                        string S_R1 = Num2BitString(S_u_R1, 5);

                        string[] S_fields = S_Type_Specifics[type].Split('_');
                        string S_func3 = S_fields[0];
                        string S_opcod = S_fields[1];

                        StringBuilder S_sb=new StringBuilder();

                        for(int j=0;j<=6;++j) S_sb.Append(S_s_imm[j]);
                        S_sb.Append(S_R2);
                        S_sb.Append(S_R1);
                        S_sb.Append(S_func3);
                        for (int j = 7; j <= 11; ++j) S_sb.Append(S_s_imm[j]);
                        S_sb.Append(S_opcod);

                        string S_instr_bin = S_sb.ToString();
                        Console.WriteLine(String.Format("Address {0:X4}, {1} , length={2}", i, type, S_instr_bin.Length));
                        string S_instr_hex = ThirtyTwoBits2EightHexDigits(S_instr_bin);

                        Tuple<string,string,string> S_instr_tuple=Tuple.Create(address,S_instr_hex, S_instr_bin);
                        result.Add(S_instr_tuple);
                        break;
                    case "beq":
                        if (!field_1.Contains("$")) throw new ApplicationException("Rs2  operand of instruction " + address + " is in invalid format");
                        if (!field_2.Contains("$")) throw new ApplicationException("Rs1 operand of instruction " + address + " is in invalid format");
                        Byte B_u_R1 = Convert.ToByte(field_1.Replace("$", "").Replace(",", ""));
                        Byte B_u_R2 = Convert.ToByte(field_2.Replace("$", "").Replace(",", ""));

                        string label_s = field_3;
                        if (!labels.ContainsKey(label_s)) throw new ApplicationException("Label in branch of instruction " + address + " does not exist in the code");
                        
                        Int16 B_i_imm = (Int16)labels[label_s];
                        UInt16 B_imm = 0;
                        B_i_imm = ((Int16)(B_i_imm - (Int16)i));
                        B_i_imm *= 2;


                        if (B_i_imm >= 0) B_imm = (UInt16)B_i_imm;
                        else B_imm = (UInt16)(((UInt16)(1 << 12) - (UInt16)(0 - B_i_imm)));
                        string B_s_imm = Num2BitString(B_imm, 12);
                        


                        string B_R2 = Num2BitString(B_u_R2, 5);
                        string B_R1 = Num2BitString(B_u_R1, 5);

                        string[] B_fields = B_Type_Specifics[type].Split('_');
                        string B_func3 = B_fields[0];
                        string B_opcod = B_fields[1];

                        StringBuilder B_sb = new StringBuilder();

                        B_sb.Append(B_s_imm[0]);
                        for (int j = 2; j <= 7; ++j) B_sb.Append(B_s_imm[j]);
                        B_sb.Append(B_R2);
                        B_sb.Append(B_R1);
                        B_sb.Append(B_func3);
                        for (int j = 8; j <= 11; ++j) B_sb.Append(B_s_imm[j]);
                        B_sb.Append(B_s_imm[1]);
                        B_sb.Append(B_opcod);

                        string B_instr_bin = B_sb.ToString();
                        Console.WriteLine(String.Format("Address {0:X4}, {1} , length={2}", i, type, B_instr_bin.Length));
                        string B_instr_hex = ThirtyTwoBits2EightHexDigits(B_instr_bin);

                        Tuple<string, string, string> B_instr_tuple = Tuple.Create(address, B_instr_hex, B_instr_bin);
                        result.Add(B_instr_tuple);
                        break;

                }
                
            }


            return result;
        }
    }
}
