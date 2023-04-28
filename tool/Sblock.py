import tkinter as tk

class Sblock:
    def __init__(self, master):
        self.bits = [0,0,0,0,0,0] # H H H V V V
        self.frame = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )
        self.frame.pack()
        self.l = 160
        self.canvas = tk.Canvas(master = self.frame, width=self.l, height=self.l)
        self.canvas.pack(side=tk.LEFT)
        self.H0 = self.canvas.create_line(0,self.l/4,self.l,self.l/4, fill='white', arrow='last', width=4)
        self.H1 = self.canvas.create_line(0,self.l/2,self.l,self.l/2, fill='white', arrow='last', width=4)
        self.H2 = self.canvas.create_line(0,self.l*3/4,self.l,self.l*3/4, fill='white', arrow='last', width=4)
        self.V0 = self.canvas.create_line(self.l/4,0,self.l/4,self.l, fill='white', arrow='last', width=4)
        self.V1 = self.canvas.create_line(self.l/2,0,self.l/2,self.l, fill='white', arrow='last', width=4)
        self.V2 = self.canvas.create_line(self.l*3/4,0,self.l*3/4,self.l, fill='white', arrow='last', width=4)
        self.btn_H0 = tk.Button(master=self.frame, text="H0", command=self.toggleH0)
        self.btn_H0.pack()
        self.btn_H1 = tk.Button(master=self.frame, text="H1", command=self.toggleH1)
        self.btn_H1.pack()
        self.btn_H2 = tk.Button(master=self.frame, text="H2", command=self.toggleH2)
        self.btn_H2.pack()
        self.btn_V0 = tk.Button(master=self.frame, text="V0", command=self.toggleV0)
        self.btn_V0.pack()
        self.btn_V1 = tk.Button(master=self.frame, text="V1", command=self.toggleV1)
        self.btn_V1.pack()
        self.btn_V2 = tk.Button(master=self.frame, text="V2", command=self.toggleV2)
        self.btn_V2.pack()
        self.label_bit = tk.Label(master=master, text="Current Bitstream:000000000000000000")
        self.label_bit.pack()
        self.copy_btn = tk.Button(master=master, text="generate", command=self.generate)
        self.copy_btn.pack()

    def get_bits(self):
        res = []
        for i in self.bits:
            res.append(i)
            res.append(i)
            res.append(i)
        return ''.join(str(n)for n in res)

    def generate(self):
        #window.clipboard_clear()
        s = self.get_bits()
        self.label_bit.config(text="Current Bitstream:"+s)
        #window.clipboard_append(s)

    def toggleH0(self):
        self.bits[0] = 1 - self.bits[0]
        if self.bits[0] == 1:
            self.canvas.itemconfig(self.H0, fill="blue")
        else:
            self.canvas.itemconfig(self.H0, fill="white")

    def toggleH1(self):
        self.bits[1] = 1 - self.bits[1]
        if self.bits[1] == 1:
            self.canvas.itemconfig(self.H1, fill="blue")
        else:
            self.canvas.itemconfig(self.H1, fill="white")

    def toggleH2(self):
        self.bits[2] = 1 - self.bits[2]
        if self.bits[2] == 1:
            self.canvas.itemconfig(self.H2, fill="blue")
        else:
            self.canvas.itemconfig(self.H2, fill="white")

    def toggleV0(self):
        self.bits[3] = 1 - self.bits[3]
        if self.bits[3] == 1:
            self.canvas.itemconfig(self.V0, fill="red")
        else:
            self.canvas.itemconfig(self.V0, fill="white")

    def toggleV1(self):
        self.bits[4] = 1 - self.bits[4]
        if self.bits[4] == 1:
            self.canvas.itemconfig(self.V1, fill="red")
        else:
            self.canvas.itemconfig(self.V1, fill="white")

    def toggleV2(self):
        self.bits[5] = 1 - self.bits[5]
        if self.bits[5] == 1:
            self.canvas.itemconfig(self.V2, fill="red")
        else:
            self.canvas.itemconfig(self.V2, fill="white")



#window = tk.Tk()
#sblock = Sblock(window)
#window.mainloop()
