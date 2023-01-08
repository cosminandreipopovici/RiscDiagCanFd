using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Messaging;
using System.Windows.Forms;
using System.Collections.Concurrent;
using System.Threading;
using System.Security.Cryptography;
using System.Runtime.InteropServices;
using System.Collections;

namespace RiscDiag_CanFd_Library
{
    public class ParametersUdpRecv
    {
        public byte[] bytes;
        public Socket handler;
        public ParametersUdpRecv(byte[] bytes, Socket handler)
        {
            this.bytes = bytes;
            this.handler = handler;
        }
    }
    public class RiscDiag_CanFd_Driver
    {
        private EndPoint remoteIpEndPoint;
        private Socket socket = null;
        private MessageQueue mq_send;
        private MessageQueue mq_recv;

        private ConcurrentDictionary<string, bool> dict;

        private TreeView treeView;

        private Thread threadUdpAcquisition = null;
        private Thread threadMessageDispacth = null;
        private Thread threadDequeueFrames = null;

        private ConcurrentQueue<UdpFrame> queue;

        private CanFrameCache cache;
        public RiscDiag_CanFd_Driver(TreeView treeView,CheckBox checkBox)
        {
            this.treeView = treeView;
            cache=new CanFrameCache(checkBox);
            dict = new System.Collections.Concurrent.ConcurrentDictionary<string, bool>(5, 5);
            dict["acq"] = true;
            dict["dis"] = true;
            dict["deq"] = true;

            dict["shw"] = true;
        }

        public void Connect(string connectionInfo) 
        {
            try
            {
                socket = new Socket(AddressFamily.InterNetwork,SocketType.Dgram, ProtocolType.Udp);
                socket.EnableBroadcast = true;
                socket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
                string[] connectionData=connectionInfo.Split(':');
                remoteIpEndPoint = new IPEndPoint(IPAddress.Parse(connectionData[0]), Convert.ToInt32(connectionData[1]));
                socket.Connect(remoteIpEndPoint);
                socket.Send(new byte[3] { 0x11, 0x96, 0xCA });

                queue=new ConcurrentQueue<UdpFrame>();

                threadDequeueFrames = new Thread(new ThreadStart(DequeueFramesThreadStart));
                threadDequeueFrames.Start();
                Thread.Sleep(100);
                threadMessageDispacth = new Thread(new ThreadStart(MessageDispatchThreadStart));
                threadMessageDispacth.Start();
                Thread.Sleep(100);
                threadUdpAcquisition = new Thread(new ThreadStart(UdpAcquisitionThreadStart));
                threadUdpAcquisition.Start();
            }
            catch(Exception e) { throw new ApplicationException("Driver connect error: " + e.Message);}
        }

        private void UdpAcquisitionThreadStart()
        {
            long cnty=0;
            byte[] data = new byte[82];
            while (dict["acq"] == true)
            {
                socket.ReceiveFrom(data, ref remoteIpEndPoint);
                //socket.BeginReceiveFrom(data, 0, 82, SocketFlags.None, ref remoteIpEndPoint, ContinueReceiving, new ParametersUdpRecv(data, socket));
                if (MessageQueue.Exists(@".\private$\CanUdpQ"))
                    mq_send = new MessageQueue(@".\private$\CanUdpQ");
                else
                    mq_send = MessageQueue.Create(@".\private$\CanUdpQ");
                System.Messaging.Message msg = new System.Messaging.Message();
                Type[] types = new Type[1];
                types[0] = typeof(UdpFrame);
                msg.Formatter = new XmlMessageFormatter(types);
                msg.Label = "f" + (cnty++).ToString("X");
                msg.Body = new UdpFrame(data);
                mq_send.Send(msg);
            }
        }

        private void MessageDispatchThreadStart()
        {
            if (MessageQueue.Exists(@".\private$\CanUdpQ"))
            {
                mq_recv = new MessageQueue(@".\private$\CanUdpQ");
            }
            else
            {
                mq_recv = MessageQueue.Create(@".\private$\CanUdpQ");
            }
            //mq.Formatter = new BinaryMessageFormatter();
            Type[] types = new Type[1];
            types[0] = typeof(UdpFrame);
            mq_recv.Formatter = new XmlMessageFormatter(types);
            while (dict["dis"]==true)
            {
                System.Messaging.Message msg = mq_recv.Receive();
                UdpFrame frame = (UdpFrame)msg.Body;
                queue.Enqueue(frame);
            }
        }

        private void DequeueFramesThreadStart()
        {
            while (dict["deq"] == true)
            {
                while (!queue.IsEmpty)
                {
                    queue.TryDequeue(out UdpFrame frame);

                    CanFrame canFrame = new CanFrame(frame);

                    object[] obArr = new object[1];
                    obArr[0] = canFrame.ToTreeNode();
                    treeView.Invoke(new AddFrameOnTree(AddFrameOnTreeview), obArr);
                }
            }
        }

        public delegate void AddFrameOnTree(TreeNode treeNode);

        private void AddFrameOnTreeview(TreeNode treeNode)
        {
            if (dict["shw"] == true)
            {
                if (treeView.Nodes.Count >= 500)
                {
                    treeView.Nodes.Clear();
                    treeView.Nodes.Add(treeNode);
                }
                else treeView.Nodes.Add(treeNode);
            }
            object[] obArr = new object[1];
            obArr[0] = treeNode.Clone();
            treeView.Invoke(new AddFrameOnCache(AddFrameOnFrameCahce), obArr);
        }

        public delegate void AddFrameOnCache(TreeNode treeNode);
        private void AddFrameOnFrameCahce(TreeNode treeNode) => AddFrameToCache(treeNode);

        private void AddFrameToCache(TreeNode treeNode) => cache.AddFrame(treeNode);

        public void Disconnect()
        {
            dict["acq"] = false; Thread.Sleep(100);
            dict["dis"] = false;  Thread.Sleep(100);
            dict["deq"] = false;   Thread.Sleep(100);

            socket.Close(); 
            socket= null;
        }

        public void PlayShowing() => dict["shw"] = true;
        public void PauseShowing() => dict["shw"] = false;
    }
}
