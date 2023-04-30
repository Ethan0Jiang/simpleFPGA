import tkinter as tk

class CLB:
    def __init__(self, master):
        self.bits = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] # out_sel[4] mux_ctrl ff_en_ctrl[2] lut[16]
        self.frame = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )
        self.frame.pack()
        self.l = 320
        self.canvas = tk.Canvas(master = self.frame, width=self.l, height=self.l)
        self.canvas.pack(side=tk.LEFT)
        self.upo = self.canvas.create_line(self.l/6,self.l,self.l/6,0, fill='blue', arrow='last', width=4)
        self.downo = self.canvas.create_line(self.l*5/6,0,self.l*5/6,self.l, fill='blue', arrow='last', width=4)
        self.righto = self.canvas.create_line(0,self.l/6,self.l,self.l/6, fill='blue', arrow='last', width=4)
        self.lefto = self.canvas.create_line(self.l,self.l*5/6,0,self.l*5/6, fill='blue', arrow='last', width=4)
        self.mux = self.canvas.create_polygon(self.l*12/16,self.l*6/16,self.l*13/16,self.l*7/16,self.l*13/16,self.l*9/16,self.l*12/16,self.l*10/16,fill='black')

        self.sig_upo = self.canvas.create_line(self.l*13/16,self.l/2,self.l/6,0, fill='white', arrow='last', width=4)
        self.sig_downo = self.canvas.create_line(self.l*13/16,self.l/2,self.l*5/6,self.l, fill='white', arrow='last', width=4)
        self.sig_righto = self.canvas.create_line(self.l*13/16,self.l/2,self.l,self.l/6, fill='white', arrow='last', width=4)
        self.sig_lefto = self.canvas.create_line(self.l*13/16,self.l/2,0,self.l*5/6, fill='white', arrow='last', width=4)

        self.lut = self.canvas.create_rectangle(self.l*4/16,self.l*6/16,self.l*6/16,self.l*10/16,fill="black")
        self.ff = self.canvas.create_rectangle(self.l*9/16,self.l*8/16,self.l*10/16,self.l*10/16,fill="black")
        self.lut_to_ff = self.canvas.create_line(self.l*6/16,self.l*9/16,self.l*9/16,self.l*9/16,fill='black',width=2)
        self.ff_to_mux = self.canvas.create_line(self.l*10/16,self.l*9/16,self.l*12/16,self.l*9/16,width=2)
        self.lut_to_mux1 = self.canvas.create_line(self.l*7/16,self.l*9/16,self.l*7/16,self.l*7/16,fill='white',width=2)
        self.lut_to_mux2 = self.canvas.create_line(self.l*7/16,self.l*7/16,self.l*12/16,self.l*7/16,fill='white',width=2)

        self.en_l = self.canvas.create_line(0,self.l/6,self.l*19/32,self.l*10/16,fill='orange',arrow='last',width=2)
        self.en_r = self.canvas.create_line(self.l,self.l*5/6,self.l*19/32,self.l*10/16,fill='white',arrow='last',width=2)
        self.en_u = self.canvas.create_line(self.l*5/6,0,self.l*19/32,self.l*10/16,fill='white',arrow='last',width=2)

        self.btn_O_U = tk.Button(master=self.frame, text="O_U", command=self.toggleO_U)
        self.btn_O_U.pack()
        self.btn_O_D = tk.Button(master=self.frame, text="O_D", command=self.toggleO_D)
        self.btn_O_D.pack()
        self.btn_O_R = tk.Button(master=self.frame, text="O_R", command=self.toggleO_R)
        self.btn_O_R.pack()
        self.btn_O_L = tk.Button(master=self.frame, text="O_L", command=self.toggleO_L)
        self.btn_O_L.pack()
        self.btn_sel = tk.Button(master=self.frame, text="sel", command=self.togglesel)
        self.btn_sel.pack()
        self.btn_en = tk.Button(master=self.frame, text="en", command=self.toggleen)
        self.btn_en.pack()
        self.entry = tk.Entry(master = self.frame)
        self.entry.pack(fill=tk.Y)
        self.label_explain = tk.Label(master=master, text="LUT input order: Up, Right, Left, Down")
        self.label_explain.pack()
        self.label_bit = tk.Label(master=master, text="Current Bitstream:00000000000000000000000")
        self.label_bit.pack()
        self.copy_btn = tk.Button(master=master, text="generate", command=self.generate)
        self.copy_btn.pack()

    def get_bits(self):
        res = self.bits
        return ''.join(str(n)for n in res)

    def generate(self):
        #window.clipboard_clear()
        equation = self.entry.get()
        if len(equation)==0:
            self.bits[7:23] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        else:
            self.bits[7:23] = self.evaluate_boolean_eqn(equation)
        s = self.get_bits()
        self.label_bit.config(text="Current Bitstream:"+s)
        #window.clipboard_append(s)

    def toggleO_U(self):
        self.bits[0] = 1 - self.bits[0]
        if self.bits[0] == 1:
            self.canvas.itemconfig(self.upo, fill="white")
            self.canvas.itemconfig(self.sig_upo, fill="red")
        else:
            self.canvas.itemconfig(self.upo, fill="blue")
            self.canvas.itemconfig(self.sig_upo, fill="white")

    def toggleO_D(self):
        self.bits[1] = 1 - self.bits[1]
        if self.bits[1] == 1:
            self.canvas.itemconfig(self.downo, fill="white")
            self.canvas.itemconfig(self.sig_downo, fill="red")
        else:
            self.canvas.itemconfig(self.downo, fill="blue")
            self.canvas.itemconfig(self.sig_downo, fill="white")

    def toggleO_R(self):
        self.bits[2] = 1 - self.bits[2]
        if self.bits[2] == 1:
            self.canvas.itemconfig(self.righto, fill="white")
            self.canvas.itemconfig(self.sig_righto, fill="red")
        else:
            self.canvas.itemconfig(self.righto, fill="blue")
            self.canvas.itemconfig(self.sig_righto, fill="white")

    def toggleO_L(self):
        self.bits[3] = 1 - self.bits[3]
        if self.bits[3] == 1:
            self.canvas.itemconfig(self.lefto, fill="white")
            self.canvas.itemconfig(self.sig_lefto, fill="red")
        else:
            self.canvas.itemconfig(self.lefto, fill="blue")
            self.canvas.itemconfig(self.sig_lefto, fill="white")

    def togglesel(self):
        self.bits[4] = 1 - self.bits[4]
        if self.bits[4] == 1:
            self.canvas.itemconfig(self.ff_to_mux, fill="white")
            self.canvas.itemconfig(self.lut_to_mux1, fill="black")
            self.canvas.itemconfig(self.lut_to_mux2, fill="black")
        else:
            self.canvas.itemconfig(self.ff_to_mux, fill="black")
            self.canvas.itemconfig(self.lut_to_mux1, fill="white")
            self.canvas.itemconfig(self.lut_to_mux2, fill="white")

    def toggleen(self):
        if self.bits[5] == 0 and self.bits[6] == 0:
            self.bits[6] = 1
            self.canvas.itemconfig(self.en_l, fill="white")
            self.canvas.itemconfig(self.en_r, fill="orange")
            self.canvas.itemconfig(self.en_u, fill="white")
            self.canvas.itemconfig(self.ff, fill="black")
        elif self.bits[5] == 0 and self.bits[6] == 1:
            self.bits[5] = 1
            self.bits[6] = 0
            self.canvas.itemconfig(self.en_l, fill="white")
            self.canvas.itemconfig(self.en_r, fill="white")
            self.canvas.itemconfig(self.en_u, fill="white")
            self.canvas.itemconfig(self.ff, fill="orange")
        elif self.bits[5] == 1 and self.bits[6] == 0:
            self.bits[6] = 1
            self.canvas.itemconfig(self.en_l, fill="white")
            self.canvas.itemconfig(self.en_r, fill="white")
            self.canvas.itemconfig(self.en_u, fill="orange")
            self.canvas.itemconfig(self.ff, fill="black")
        elif self.bits[5] == 1 and self.bits[6] == 1:
            self.bits[5] = 0
            self.bits[6] = 0
            self.canvas.itemconfig(self.en_l, fill="orange")
            self.canvas.itemconfig(self.en_r, fill="white")
            self.canvas.itemconfig(self.en_u, fill="white")
            self.canvas.itemconfig(self.ff, fill="black")

    def evaluate_boolean_eqn(self, eq_str):
        inputs = [False, True] ############ maybe wrong here!!!!
        output = []
        for a in inputs:
            for b in inputs:
                for c in inputs:
                    for d in inputs:
                        val = eval(eq_str)
                        output.append(val)
        output = [int(n) for n in output]
        return output

#window = tk.Tk()
#sblock = CLB(window)
#window.mainloop()
