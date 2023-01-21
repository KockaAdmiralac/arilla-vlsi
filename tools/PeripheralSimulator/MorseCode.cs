using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PeripheralSimulator
{
    public partial class MorseCode : Form, Peripheral
    {
        public string input = "";
        public string output = "";
        public bool inNempty;
        public bool outNempty;
        public uint res = 0;

        public char pop(ref string s) 
        {
            if (s.Length > 0)
            {
                char c = s[0];
                s = s.Substring(1);
                inNempty = s.Length>0;
                return c;
            }
            else 
            {
                return ' ';
            }
        }

        public void push(ref string s, char c) 
        {
            s = s + c;
            outNempty = true;
        }

        public void transmit() 
        {
            input = output;
            output = "";
            inNempty = true;
            outNempty = false;
        }

        public MorseCode()
        {
            InitializeComponent();

            Location = new Point(1300, 10);

            textBox1.Text = output;
            textBox2.Text = input;
            label1.Text = res.ToString();

            Show();
        }

        public uint getBaseAddress()
        {
            return 0x40000000;
        }

        public uint getSize()
        {
            return 3;
        }

        public uint read(uint address)
        {
            switch (address - getBaseAddress()) 
            {
                case 0: {
                        return Status();
                    }
                case 8: { 
                        char c = pop(ref input);
                        UpdateUi();
                        return c;
                    }
            }
            return 0;
        }

        public uint Status() 
        {
            uint res = 0;
            if (outNempty) 
            {
                res |= 0x4;
            }
            if (inNempty) 
            {
                res |= 0x1;
            }
            this.res = res;
            UpdateUi();
            return res;
        }

        public void write(uint address, uint value)
        {
            switch (address - getBaseAddress())
            {
                case 0: {
                        if ((value & 0x20) != 0) 
                        {
                            transmit();
                        }
                        UpdateUi();
                        return;
                    }
                case 8: { 
                        push(ref output,(char)(value&0x7F));
                        UpdateUi();
                        return;
                    }
            }
        }

        public void UpdateUi() 
        {
            this.Invoke(new Action(()=>{
                textBox1.Text = output;
                textBox2.Text = input;
                label1.Text = res.ToString();
            }));
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}
