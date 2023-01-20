using System;
using System.CodeDom;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace PeripheralSimulator
{
    public partial class gpu : Form, Peripheral
    {
        uint[] regs = new uint[4];
        int mss = 0;
        int lss = 0;

        Graphics g;
        Pen p;
        SolidBrush sb;
        Bitmap bmp;

        mouse m;
        keyboard k;

        public gpu(mouse m, keyboard k)
        {
            InitializeComponent();

            Location = new Point(450, 10);

            this.m = m;
            this.k = k;

            Updatetext();

            Show();
        }

        private void gpu_Load(object sender, EventArgs e)
        {
            bmp = new Bitmap(800, 600);
            g = Graphics.FromImage(bmp);
            pbCanvas.Image = bmp;
            p = new Pen(Color.Black);
            sb = new SolidBrush(Color.Black);
        }

        private void Updatetext()
        {
            bool on = (regs[0] & 1) != 0;
            bool cursor = (regs[0] & 4) != 0;
            Text = $"VGA 800x600 OUTPUT:{(on ? "ON" : "OFF")} CRUSOR:{(cursor ? "ON" : "OFF")} MSS:{mss} LSS:{lss} KBD:{k.reg.ToString("X")}";
        }

        public uint getBaseAddress()
        {
            return 0x20000000;
        }

        public uint getSize()
        {
            return 4;
        }

        public uint read(uint address)
        {
            return regs[(address - getBaseAddress()) / 4];
        }

        public void write(uint address, uint value)
        {
            if (address == getBaseAddress() && (value & 1) == 1 && (regs[0] & 1) == 0)
            {
                //Power ON
                regs[1] |= 1;
            }
            regs[(address - getBaseAddress()) / 4] = value;
            if (address == getBaseAddress())
            {
                doWork();
            }
        }

        public void doWork()
        {
            this.Invoke(new Action(() =>
            {
                Updatetext();
                UpdateColor();
                if ((regs[0] & 2) != 0)
                {
                    regs[0] &= ~(uint)2;
                    regs[1] &= ~(uint)1;


                    doOpcode((regs[0] & 0xE0) >> 5);

                    regs[1] |= 1;
                }
            }));
        }

        private void UpdateColor()
        {
            uint blue = ((regs[0] >> 20) & 0xF) << 4;
            uint green = ((regs[0] >> 24) & 0xF) << 4;
            uint red = ((regs[0] >> 28) & 0xF) << 4;
            Color c = Color.FromArgb((int)red, (int)green, (int)blue);
            p.Color = c;
            sb.Color = c;
        }

        private void doOpcode(uint v)
        {
            int xs = (int)(regs[2] & 0x3FF);
            int ys = (int)(regs[2] >> 10);
            int xe = (int)(regs[3] & 0x3FF);
            int ye = (int)(regs[3] >> 10);
            switch (v)
            {
                case 0:
                    {
                        g.FillRectangle(sb, xs, ys, 1, 1);
                        pbCanvas.Invalidate();
                        break;
                    }
                case 1:
                    {
                        g.DrawLine(p, xs, ys, xe, ye);
                        pbCanvas.Invalidate();
                        break;
                    }
                case 2:
                    {
                        g.DrawRectangle(p, Math.Min(xs, xe), Math.Min(ys, ye), Math.Abs(xe - xs), Math.Abs(ye - ys));
                        pbCanvas.Invalidate();
                        break;
                    }
                case 3:
                    {
                        g.FillRectangle(sb, Math.Min(xs, xe), Math.Min(ys, ye), Math.Abs(xe - xs) + 1, Math.Abs(ye - ys) + 1);
                        pbCanvas.Invalidate();
                        break;
                    }
                case 4:
                    {
                        Color c = bmp.GetPixel(xs, ys);
                        uint color = checked((((uint)(c.R) >> 4) << 28) | (((uint)(c.G) >> 4) << 24) | (((uint)(c.B) >> 4) << 20));
                        regs[1] &= ~0xFFF00000;
                        regs[1] |= color;
                        break;
                    }
                    //TMP FloodFill
                    //case 5:
                    //    {
                    //        //Temp testing FloodFill
                    //        FloodFill(p, (uint)xs, (uint)ys);
                    //        break;
                    //    }
            }
        }

        public struct StackField
        {
            public uint x;
            public uint y;

            public override string ToString()
            {
                return $"X:{x} Y:{y}";
            }
        }

        private void FloodFill(Pen p, uint xs, uint ys)
        {
            Color src = bmp.GetPixel((int)xs, (int)ys);
            Color dst = p.Color;
            if (dst == src) { return; }
            lss = 0;

            int maxStack = 200;

            StreamWriter sw = new StreamWriter("StackLog.txt");

            Stack<StackField> S = new Stack<StackField>();
            if (S.Count < 200) { S.Push(new StackField { x = xs, y = ys }); }
            sw.WriteLine("PUSH: " + S.Peek().ToString());
            if (S.Count > lss) { lss = S.Count; Updatetext(); }
            while (S.Count != 0)
            {
                StackField t = S.Pop();
                sw.WriteLine("POP:  " + t.ToString());
                if (bmp.GetPixel((int)t.x, (int)t.y) == src)
                {
                    bool setabove = false;
                    bool setbelow = false;
                    bool setsecondabove = false;
                    bool setsecondbelow = false;
                    if ((t.y - 1) < 600 - 64)
                    {
                        if (bmp.GetPixel((int)t.x, (int)t.y - 1) == src)
                        {
                            if (S.Count < 200)
                            {
                                S.Push(new StackField { x = t.x, y = t.y - 1 });
                            }
                            sw.WriteLine("PUSH: " + S.Peek().ToString());
                            if (S.Count > lss) { lss = S.Count; Updatetext(); }
                            setbelow = true;
                            setsecondbelow = true;
                        }
                    }
                    if ((t.y + 1) < 600 - 64)
                    {
                        if (bmp.GetPixel((int)t.x, (int)t.y + 1) == src)
                        {
                            if (S.Count < 200)
                            {
                                S.Push(new StackField { x = t.x, y = t.y + 1 });
                            }
                            sw.WriteLine("PUSH: " + S.Peek().ToString());
                            if (S.Count > lss) { lss = S.Count; Updatetext(); }
                            setabove = true;
                            setsecondabove = true;
                        }
                    }
                    uint minx = t.x - 1;
                    uint maxx = t.x + 1;
                    while (minx < 800 && bmp.GetPixel((int)minx, (int)t.y) == src)
                    {
                        if ((t.y - 1) < 600 - 64)
                        {
                            if (bmp.GetPixel((int)minx, (int)t.y - 1) == src)
                            {
                                if (!setbelow)
                                {
                                    if (S.Count < 200)
                                    {
                                        S.Push(new StackField { x = minx, y = t.y - 1 });
                                    }
                                    sw.WriteLine("PUSH: " + S.Peek().ToString());
                                    if (S.Count > lss) { lss = S.Count; Updatetext(); }
                                    setbelow = true;
                                }
                            }
                            else
                            {
                                setbelow = false;
                            }
                        }
                        if ((t.y + 1) < 600 - 64)
                        {
                            if (bmp.GetPixel((int)minx, (int)t.y + 1) == src)
                            {
                                if (!setabove)
                                {
                                    if (S.Count < 200)
                                    {
                                        S.Push(new StackField { x = minx, y = t.y + 1 });
                                    }
                                    sw.WriteLine("PUSH: " + S.Peek().ToString());
                                    if (S.Count > lss) { lss = S.Count; Updatetext(); }
                                    setabove = true;
                                }
                            }
                            else
                            {
                                setabove = false;
                            }
                        }
                        minx--;
                    }
                    minx++;
                    while (maxx < 800 && bmp.GetPixel((int)maxx, (int)t.y) == src)
                    {
                        if ((t.y - 1) < 600 - 64)
                        {
                            if (bmp.GetPixel((int)maxx, (int)t.y - 1) == src)
                            {
                                if (!setsecondbelow)
                                {
                                    if (S.Count < 200)
                                    {
                                        S.Push(new StackField { x = maxx, y = t.y - 1 });
                                    }
                                    sw.WriteLine("PUSH: " + S.Peek().ToString());
                                    if (S.Count > lss) { lss = S.Count; Updatetext(); }
                                    setsecondbelow = true;
                                }
                            }
                            else
                            {
                                setsecondbelow = false;
                            }
                        }
                        if ((t.y + 1) < 600 - 64)
                        {
                            if (bmp.GetPixel((int)maxx, (int)t.y + 1) == src)
                            {
                                if (!setsecondabove)
                                {
                                    if (S.Count < 200)
                                    {
                                        S.Push(new StackField { x = maxx, y = t.y + 1 });
                                    }
                                    sw.WriteLine("PUSH: " + S.Peek().ToString());
                                    if (S.Count > lss) { lss = S.Count; Updatetext(); }
                                    setsecondabove = true;
                                }
                            }
                            else
                            {
                                setsecondabove = false;
                            }
                        }
                        maxx++;
                    }
                    maxx--;
                    if (minx == maxx)
                    {
                        g.FillRectangle(sb, minx, t.y, 1, 1);
                    }
                    else
                    {
                        g.DrawLine(p, minx, t.y, maxx, t.y);
                    }
                }
            }
            if (lss > mss) { mss = lss; Updatetext(); }
            sw.Close();
            pbCanvas.Invalidate();
        }

        private void gpu_MouseDown(object sender, MouseEventArgs e)
        {
            m.mouseDown(e);
        }

        private void gpu_MouseUp(object sender, MouseEventArgs e)
        {
            m.mouseUp(e);
        }

        private void gpu_MouseMove(object sender, MouseEventArgs e)
        {
            m.mouseMove(e);
        }

        public class mouse : Peripheral
        {
            uint[] regs = new uint[2];
            uint lastX = 0;
            uint lastY = 0;

            public uint getBaseAddress()
            {
                return 0x10000000;
            }

            public uint getSize()
            {
                return 2;
            }

            public uint read(uint address)
            {
                uint val = regs[(address - getBaseAddress()) / 4];
                if (address == getBaseAddress() + 4)
                {
                    regs[1] &= ~(uint)8;
                }
                return val;
            }

            public void write(uint address, uint value)
            {
                regs[(address - getBaseAddress()) / 4] = value;
            }

            internal void mouseDown(MouseEventArgs e)
            {
                if ((regs[0] & 1) != 0)
                {
                    if (e.Button == MouseButtons.Left)
                    {
                        regs[1] |= 2;
                    }
                    else
                    {
                        regs[1] |= 4;
                    }
                }
            }

            internal void mouseUp(MouseEventArgs e)
            {
                if ((regs[0] & 1) != 0)
                {
                    if (e.Button == MouseButtons.Left)
                    {
                        regs[1] &= ~(uint)2;
                    }
                    else
                    {
                        regs[1] &= ~(uint)4;
                    }
                }
            }

            internal void mouseMove(MouseEventArgs e)
            {
                uint x = (uint)Math.Min(Math.Max(0, e.X), 799);
                uint y = (uint)Math.Min(Math.Max(0, e.Y), 599);
                if (x != lastX || y != lastY)
                {
                    regs[1] |= 8;
                    regs[1] &= 0xFFF;
                    regs[1] |= (x & 0x3FF) << 12;
                    regs[1] |= (y & 0x3FF) << 22;
                    lastX = x;
                    lastY = y;
                }
            }
        }

        private void gpu_KeyDown(object sender, KeyEventArgs e)
        {
            k.KeyDown(e);
            Updatetext();
        }

        private void gpu_KeyUp(object sender, KeyEventArgs e)
        {
            k.KeyUp(e);
            Updatetext();
        }

        public class keyboard : Peripheral
        {

            public uint reg = 0;
            bool CDC = true;
            bool deb = true;

            Random r = new Random();
            public uint getBaseAddress()
            {
                return 0x30000000;
            }

            public uint getSize()
            {
                return 1;
            }

            public uint read(uint address)
            {
                return reg;
            }

            public void write(uint address, uint value)
            {
                CDC = (value & 0x04000000) == 0;
                deb = (value & 0x08000000) == 0;
            }
            public void KeyDown(KeyEventArgs e)
            {
                reg = GetScanCode(e);
                reg |= (uint)((r.Next() % 2 == 0) && CDC ? 0x01000000 : 0x00000000);
                reg |= (uint)((r.Next() % 2 == 0) && deb ? 0x02000000 : 0x00000000);
            }

            private uint GetScanCode(KeyEventArgs e)
            {
                switch (e.KeyCode)
                {
                    case Keys.A: { return 0x1C; }
                    case Keys.B: { return 0x32; }
                    case Keys.C: { return 0x21; }
                    case Keys.D: { return 0x23; }
                    case Keys.E: { return 0x24; }
                    case Keys.F: { return 0x2B; }
                    case Keys.G: { return 0x34; }
                    case Keys.H: { return 0x33; }
                    case Keys.I: { return 0x43; }
                    case Keys.J: { return 0x3B; }
                    case Keys.K: { return 0x42; }
                    case Keys.L: { return 0x4B; }
                    case Keys.M: { return 0x3A; }
                    case Keys.N: { return 0x31; }
                    case Keys.O: { return 0x44; }
                    case Keys.P: { return 0x4D; }
                    case Keys.Q: { return 0x15; }
                    case Keys.R: { return 0x2D; }
                    case Keys.S: { return 0x1B; }
                    case Keys.T: { return 0x2C; }
                    case Keys.U: { return 0x3C; }
                    case Keys.V: { return 0x2A; }
                    case Keys.W: { return 0x1D; }
                    case Keys.X: { return 0x22; }
                    case Keys.Y: { return 0x35; }
                    case Keys.Z: { return 0x1A; }

                    case Keys.Oemtilde: { return 0x0E; }
                    case Keys.OemQuotes: { return 0x52; }
                    case Keys.Oemcomma: { return 0x41; }
                    case Keys.OemMinus: { return 0x4E; }
                    case Keys.OemPeriod: { return 0x49; }
                    case Keys.OemSemicolon: { return 0x4C; }
                    case Keys.OemQuestion: { return 0x4A; }
                    case Keys.Oemplus: { return 0x55; }
                    case Keys.OemOpenBrackets: { return 0x54; }
                    case Keys.OemCloseBrackets: { return 0x5B; }
                    case Keys.OemPipe: { return 0x5D; }


                    case Keys.Space: { return 0x29; }
                    case Keys.Enter: { return 0x5A; }
                    case Keys.Escape: { return 0x76; }
                    case Keys.Tab: { return 0x0D; }
                    case Keys.Back: { return 0x66; }


                    case Keys.Scroll: { return 0x7E; }
                    case Keys.CapsLock: { return 0x58; }
                    case Keys.NumLock: { return 0x77; }

                    case Keys.Delete: { return 0xE071; }
                    case Keys.End: { return 0xE069; }
                    case Keys.Home: { return 0xE06C; }
                    case Keys.Insert: { return 0xE070; }
                    case Keys.PageDown: { return 0xE07A; }
                    case Keys.PageUp: { return 0xE07D; }

                    case Keys.Up: { return 0xE075; }
                    case Keys.Down: { return 0xE072; }
                    case Keys.Left: { return 0xE06B; }
                    case Keys.Right: { return 0xE074; }

                    case Keys.Alt: { return 0x11; }

                    case Keys.LShiftKey: case Keys.ShiftKey: { return 0x12; }
                    case Keys.RShiftKey: { return 0x59; }
                    case Keys.LControlKey: case Keys.ControlKey: { return 0x14; }
                    case Keys.RControlKey: { return 0xE014; }
                    case Keys.LMenu: case Keys.Menu:  { return 0xE02F; }
                    case Keys.RMenu: { return 0xE02F; }
                    case Keys.LWin: { return 0xE01F; }
                    case Keys.RWin: { return 0xE027; }

                    case Keys.D1: { return 0x16; }
                    case Keys.D2: { return 0x1E; }
                    case Keys.D3: { return 0x26; }
                    case Keys.D4: { return 0x25; }
                    case Keys.D5: { return 0x2E; }
                    case Keys.D6: { return 0x36; }
                    case Keys.D7: { return 0x3D; }
                    case Keys.D8: { return 0x3E; }
                    case Keys.D9: { return 0x46; }
                    case Keys.D0: { return 0x45; }

                    case Keys.NumPad1: { return 0x69; }
                    case Keys.NumPad2: { return 0x72; }
                    case Keys.NumPad3: { return 0x7A; }
                    case Keys.NumPad4: { return 0x6B; }
                    case Keys.NumPad5: { return 0x73; }
                    case Keys.NumPad6: { return 0x74; }
                    case Keys.NumPad7: { return 0x6C; }
                    case Keys.NumPad8: { return 0x75; }
                    case Keys.NumPad9: { return 0x7D; }
                    case Keys.NumPad0: { return 0x70; }
                    case Keys.Decimal: { return 0x71; }
                    case Keys.Multiply: { return 0x7C; }
                    case Keys.Add: { return 0x79; }
                    case Keys.Subtract: { return 0x7B; }
                    case Keys.Divide: { return 0xE04A; }

                    case Keys.F1: { return 0x05; }
                    case Keys.F2: { return 0x06; }
                    case Keys.F3: { return 0x04; }
                    case Keys.F4: { return 0x0C; }
                    case Keys.F5: { return 0x03; }
                    case Keys.F6: { return 0x0B; }
                    case Keys.F7: { return 0x83; }
                    case Keys.F8: { return 0x0A; }
                    case Keys.F9: { return 0x01; }
                    case Keys.F10: { return 0x09; }
                    case Keys.F11: { return 0x78; }
                    case Keys.F12: { return 0x07; }
                }
                return 0;
            }

            public uint GetBreakCode(KeyEventArgs e) 
            {
                uint code = GetScanCode(e);
                if ((code & 0xFF00) == 0)
                {
                    code = 0xF000 | code;
                }
                else 
                {
                    code = 0xE0F000 | (code & 0xFF);
                }
                return code;
            }

            public void KeyUp(KeyEventArgs e)
            {
                reg = GetBreakCode(e);
                reg |= (uint)((r.Next() % 2 == 0) && CDC ? 0x01000000 : 0x00000000);
                reg |= (uint)((r.Next() % 2 == 0) && deb ? 0x02000000 : 0x00000000);
            }
        }
    }
}
