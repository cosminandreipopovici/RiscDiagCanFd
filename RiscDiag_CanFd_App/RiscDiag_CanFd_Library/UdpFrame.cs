using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RiscDiag_CanFd_Library
{
    [Serializable]
    public class UdpFrame
    {
        public byte[] data;
        public UdpFrame() { }
        public UdpFrame(byte[] data)
        {
            this.data = new byte[data.Length];
            for (int i = 0; i < data.Length; ++i) this.data[i] = data[i];
        }
    }
}
