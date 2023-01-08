using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RiscDiag_CanFd_Library
{
    public class CanFrame
    {
        public string str_ID;
        public UInt32 num_ID;

        public string str_RTR;
        public byte   num_RTR;

        public string str_IDE;
        public Byte   num_IDE;

        public string str_FDF;
        public Byte   num_FDF;

        public string str_DLC;
        public Byte   num_DLC;
        public int    num_len;

        public string str_timestamp_part1;
        public string str_timestamp_part2;
        public string str_timestamp;
        public UInt64 num_timestamp;

        public string str_payload;
        public byte[] num_payload;

        
        public string str_type;
        private byte errcode;
        
        private string errorstring;

        private byte num_errcode_type;
        private byte num_errcode_posi;
        private string error_type;
        private string error_posi;

        public const string FRAME_TYPE_RX = "FR_RX";
        public const string FRAME_TYPE_ER = "FR_ER";
        public const string FRAME_TYPE_UK = "FR_UK";

        private const string generic_error_type = "ERROR_TYPE = | ERC_GENERIC_ERROR , ";

        private Dictionary<byte,string> dict_error_type=new Dictionary<byte, string>()
        {
            {0,"ERROR_TYPE = | ERC_BIT_ERROR"},
            {1,"ERROR_TYPE = | ERC_CRC_ERROR"},
            {2,"ERROR_TYPE = | ERC_FRM_ERROR"},
            {3,"ERROR_TYPE = | ERC_ACK_ERROR"},
            {4,"ERROR_TYPE = | ERC_STF_ERROR"}
        };

        private const string generic_error_posi = "ERROR_POSITION = | ERC_GENERIC_ERROR";

        private Dictionary<byte, string> dict_error_posi = new Dictionary<byte, string>()
        {
            {0 ,"ERROR_SUBTYPE = | ERC_SOF"},
            {1 ,"ERROR_SUBTYPE = | ERC_ARB"},
            {2 ,"ERROR_SUBTYPE = | ERC_CTRL"},
            {3 ,"ERROR_SUBTYPE = | ERC_DATA"},
            {4 ,"ERROR_SUBTYPE = | ERC_CRC"},
            {5 ,"ERROR_SUBTYPE = | ERC_ACK"},
            {6 ,"ERROR_SUBTYPE = | ERC_EOF"},
            {7 ,"ERROR_SUBTYPE = | ERC_ERR"},
            {8 ,"ERROR_SUBTYPE = | ERC_OVRL"},
            {31,"ERROR_SUBTYPE = | ERC_OTHER"}
        };

        private void UdpFrame_2_CanFrame(byte[] data)
        {
            switch (data[80])
            {
                case 0xA0:
                    str_type = FRAME_TYPE_RX;
                    break;
                case 0xB0:
                    str_type = FRAME_TYPE_ER;
                    errcode = data[81];
                    break;
                default:
                    str_type = FRAME_TYPE_UK;
                    break;
            }

            if (str_type.Equals(FRAME_TYPE_RX))
            {
                num_DLC = (Byte)(data[3] & 0x0F);
                str_DLC = num_DLC.ToString();
                num_len = Dlc2Len(num_DLC);

                num_RTR = (byte)(((data[3] & 0x20) != 0x00) ? 1 : 0); str_RTR = num_RTR.ToString();
                num_IDE = (byte)(((data[3] & 0x40) != 0x00) ? 1 : 0); str_IDE = num_IDE.ToString();
                num_FDF = (byte)(((data[3] & 0x80) != 0x00) ? 1 : 0); str_FDF = num_FDF.ToString();

                num_ID = 0;
                num_ID |= (((UInt32)(data[4])) << (3 * 8));
                num_ID |= (((UInt32)(data[5])) << (2 * 8));
                num_ID |= (((UInt32)(data[6])) << (1 * 8));
                num_ID |= (((UInt32)(data[7])) << (0 * 8));
                if (num_IDE == 0) num_ID >>= 18;
                str_ID = num_ID.ToString("X8");

                num_timestamp = 0;
                num_timestamp |= (((UInt64)(data[12])) << (7 * 8)); //timestamp H
                num_timestamp |= (((UInt64)(data[13])) << (6 * 8));
                num_timestamp |= (((UInt64)(data[14])) << (5 * 8));
                num_timestamp |= (((UInt64)(data[15])) << (4 * 8));
                num_timestamp |= (((UInt64)(data[8])) << (3 * 8)); //timestamp L
                num_timestamp |= (((UInt64)(data[9])) << (2 * 8));
                num_timestamp |= (((UInt64)(data[10])) << (1 * 8));
                num_timestamp |= (((UInt64)(data[11])) << (0 * 8));
                str_timestamp_part1 = ((num_timestamp * 10) / 1000000).ToString();
                str_timestamp_part2 = ((num_timestamp * 10) % 1000000).ToString("D6");
                str_timestamp = str_timestamp_part1 + "." + str_timestamp_part2 + " ms";

                
                if (num_len > 0)
                {
                    StringBuilder sb = new StringBuilder();
                    num_payload = new byte[num_len];
                    for (int i = 16; i < num_len - 1 + 16; ++i)
                    {
                        num_payload[i - 16] = data[i];
                        sb.Append(data[i].ToString("X2")); sb.Append(' ');
                    }
                    num_payload[num_len - 1] = data[num_len - 1 + 16];
                    sb.Append(data[num_len - 1 + 16].ToString("X2"));
                    str_payload = sb.ToString();
                }
                else
                {
                    num_payload = null;
                    str_payload = "(none)";
                }
                 
            }
            else if (str_type.Equals(FRAME_TYPE_ER))
            {
                num_errcode_type = (byte)((errcode >> 5) & 0x07);
                num_errcode_posi = (byte)((errcode >> 0) & 0x1F);
                error_type = (dict_error_type.ContainsKey(num_errcode_type) ? dict_error_type[num_errcode_type] : generic_error_type);
                error_posi = (dict_error_posi.ContainsKey(num_errcode_posi) ? dict_error_posi[num_errcode_posi] : generic_error_posi);
                errorstring = FRAME_TYPE_ER+ " : " + errcode.ToString("X2")+" : "+error_type + " , " + error_posi;
            }
        }

        private int Dlc2Len(byte dlc)
        {
            switch (dlc)
            {
                case 0: 
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 7:
                case 8:
                    return dlc;
                case 9 : return 12;
                case 10: return 16;
                case 11: return 20;
                case 12: return 24;
                case 13: return 32;
                case 14: return 48;
                case 15: return 64;
                default: return 0;
            }
        }

        public override string ToString()
        {
            if (str_type.Equals(FRAME_TYPE_RX))
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(str_timestamp); sb.Append("|");
                sb.Append(str_type); sb.Append("|");
                sb.Append(str_ID); sb.Append("||");
                sb.Append(str_IDE); sb.Append("|");
                sb.Append(str_FDF); sb.Append("|");
                sb.Append(str_RTR); sb.Append("||");
                sb.Append(str_DLC); sb.Append("||");
                sb.Append(str_payload);
                return sb.ToString();
            }
            else if (str_type.Equals(FRAME_TYPE_ER))
            {
                return errorstring;
            }
            else return "unknowkn frame type";
            
        }

        public TreeNode ToTreeNode()
        {
            TreeNode treeNode = new TreeNode(ToString());

            if (str_type.Equals(FRAME_TYPE_RX))
            {
                treeNode.Nodes.Add("Timestamp : " + str_timestamp);
                treeNode.Nodes.Add("Type      : " + str_type);
                treeNode.Nodes.Add("ID        : " + str_timestamp);
                treeNode.Nodes.Add("IDE       : " + str_IDE);
                treeNode.Nodes.Add("FDF       : " + str_FDF);
                treeNode.Nodes.Add("RTR       : " + str_RTR);
                treeNode.Nodes.Add("DLC       : " + str_DLC);
                treeNode.Nodes.Add("Payload   : " + str_payload);
                int length = num_len;
                int sepCnt = 0;
                if (length > 0)
                {
                    if (length < 8)
                    {
                        sepCnt = length;
                    }
                    else
                    {
                        if (length % 8 == 0) sepCnt = 8;
                        else if (length % 4 == 0) sepCnt = 4;
                        else sepCnt = 2;
                    }
                    //StringBuilder sb_Payload=new StringBuilder();
                    string[] str_payload_ = str_payload.Split(' ');
                    TreeNode payloadNode = new TreeNode("Payload:");
                    for (int i = 0; i < length / sepCnt; ++i)
                    {
                        StringBuilder sb_PayloadRow = new StringBuilder();
                        for (int j = 0; j < sepCnt; ++j) sb_PayloadRow.Append(num_payload[i * sepCnt + j].ToString("X2") + " ");
                        sb_PayloadRow.Append("        ");
                        for (int j = 0; j < sepCnt; ++j) sb_PayloadRow.Append((char)(num_payload[i * sepCnt + j]) + " ");
                        sb_PayloadRow.Append("\r\n");
                        payloadNode.Nodes.Add(sb_PayloadRow.ToString());
                    }
                    payloadNode.Expand();
                    treeNode.Nodes.Add(payloadNode);
                } 
            }
            else if (str_type.Equals(FRAME_TYPE_ER))
            {
                treeNode.Nodes.Add("Error Code         : " + errcode.ToString("X2"));

                TreeNode treeNode_error_type = new TreeNode("Error Type");
                treeNode_error_type.Nodes.Add("Error Type Code    : " + num_errcode_type.ToString("X2"));
                treeNode_error_type.Nodes.Add("Error Type Str     : " + error_type);
                treeNode_error_type.Expand();

                TreeNode treeNode_error_posi = new TreeNode("Error Subtype");
                treeNode_error_posi.Nodes.Add("Error Subtype Code : " + num_errcode_posi.ToString("X2"));
                treeNode_error_posi.Nodes.Add("Error Subtype Str  : " + error_posi);
                treeNode_error_posi.Expand();

                treeNode.Nodes.Add(treeNode_error_type);
                treeNode.Nodes.Add(treeNode_error_posi);
            }   
            return treeNode;
        }

        public CanFrame(UdpFrame udpFrame) { UdpFrame_2_CanFrame(udpFrame.data); }
    }
}
