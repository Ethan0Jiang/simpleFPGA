import tkinter as tk

class dot_left: #was down
    def __init__(self, master, row, column):
        self.bits = [0,0,0] # UR, LD, V, now is UL, RD, H
        self.frame = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )
        #self.frame.pack()
        self.frame.grid(row=row, column=column)
        self.canvas = tk.Canvas(master = self.frame, width=100, height=100)
        self.canvas.pack(side=tk.TOP)
        self.UR = self.canvas.create_line(100,50,50,100, fill='white', arrow='last', width=4)
        self.LD = self.canvas.create_line(50,0,0,50, fill='white', arrow='last', width=4)
        self.V = self.canvas.create_line(100,50,0,50, fill='white', arrow='last', width=4)
        self.highway = self.canvas.create_line(50,0,50,100, fill='brown', arrow='last', width=6)
        self.btn_merge = tk.Button(master=self.frame, text="merge", command=self.togglemerge)
        self.btn_merge.pack()
        self.btn_exit = tk.Button(master=self.frame, text="exit", command=self.toggleexit)
        self.btn_exit.pack()
        self.btn_keep = tk.Button(master=self.frame, text="keep", command=self.togglekeep)
        self.btn_keep.pack()

    def togglemerge(self):
        self.bits[0] = 1 - self.bits[0]
        if self.bits[0] == 1:
            self.canvas.itemconfig(self.UR, fill="blue")
        else:
            self.canvas.itemconfig(self.UR, fill="white")

    def toggleexit(self):
        self.bits[1] = 1 - self.bits[1]
        if self.bits[1] == 1:
            self.canvas.itemconfig(self.LD, fill="blue")
        else:
            self.canvas.itemconfig(self.LD, fill="white")

    def togglekeep(self):
        self.bits[2] = 1 - self.bits[2]
        if self.bits[2] == 1:
            self.canvas.itemconfig(self.V, fill="blue")
        else:
            self.canvas.itemconfig(self.V, fill="white")

    def get_bits_UR(self):
        return self.bits[0]

    def get_bits_LD(self):
        return self.bits[1]

    def get_bits_V(self):
        return self.bits[2]

class dot_right: #was up
    def __init__(self, master, row, column):
        self.bits = [0,0,0] # was LU, DR, V, now TR, LD, H
        self.frame = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )
        #self.frame.pack()
        self.frame.grid(row=row, column=column)
        self.canvas = tk.Canvas(master = self.frame, width=100, height=100)
        self.canvas.pack(side=tk.BOTTOM)
        self.LU = self.canvas.create_line(50,0,100,50, fill='white', arrow='last', width=4)
        self.DR = self.canvas.create_line(0,50,50,100, fill='white', arrow='last', width=4)
        self.V = self.canvas.create_line(0,50,100,50, fill='white', arrow='last', width=4)
        self.highway = self.canvas.create_line(50,0,50,100, fill='brown', arrow='last', width=6)
        self.btn_merge = tk.Button(master=self.frame, text="merge", command=self.togglemerge)
        self.btn_merge.pack()
        self.btn_exit = tk.Button(master=self.frame, text="exit", command=self.toggleexit)
        self.btn_exit.pack()
        self.btn_keep = tk.Button(master=self.frame, text="keep", command=self.togglekeep)
        self.btn_keep.pack()

    def toggleexit(self):
        self.bits[0] = 1 - self.bits[0]
        if self.bits[0] == 1:
            self.canvas.itemconfig(self.LU, fill="blue")
        else:
            self.canvas.itemconfig(self.LU, fill="white")

    def togglemerge(self):
        self.bits[1] = 1 - self.bits[1]
        if self.bits[1] == 1:
            self.canvas.itemconfig(self.DR, fill="blue")
        else:
            self.canvas.itemconfig(self.DR, fill="white")

    def togglekeep(self):
        self.bits[2] = 1 - self.bits[2]
        if self.bits[2] == 1:
            self.canvas.itemconfig(self.V, fill="blue")
        else:
            self.canvas.itemconfig(self.V, fill="white")

    def get_bits_LU(self):
        return self.bits[0]

    def get_bits_DR(self):
        return self.bits[1]

    def get_bits_V(self):
        return self.bits[2]

class Cblock2:
    def __init__(self, master):
        self.rightdot0 = dot_right(master, 0, 0)
        self.rightdot1 = dot_right(master, 0, 1)
        self.rightdot2 = dot_right(master, 0, 2)
        self.leftdot0 = dot_left(master, 1, 0)
        self.leftdot1 = dot_left(master, 1, 1)
        self.leftdot2 = dot_left(master, 1, 2)
        self.label_bit = tk.Label(master=master, text="Current Bitstream:000000000000000000")
        self.label_bit.grid(row=3, columnspan=3)
        self.copy_btn = tk.Button(master=master, text="generate", command=self.cpy)
        self.copy_btn.grid(row=4, columnspan=3)

    def get_bits(self):
        V = []
        V.append(self.rightdot0.get_bits_V())
        V.append(self.rightdot1.get_bits_V())
        V.append(self.rightdot2.get_bits_V())
        V.append(self.leftdot2.get_bits_V())
        V.append(self.leftdot1.get_bits_V())
        V.append(self.leftdot0.get_bits_V())
        LU = []
        LU.append(self.rightdot2.get_bits_LU())
        LU.append(self.rightdot1.get_bits_LU())
        LU.append(self.rightdot0.get_bits_LU())
        DR = []
        DR.append(self.rightdot2.get_bits_DR())
        DR.append(self.rightdot1.get_bits_DR())
        DR.append(self.rightdot0.get_bits_DR())
        UR = []
        UR.append(self.leftdot2.get_bits_UR())
        UR.append(self.leftdot1.get_bits_UR())
        UR.append(self.leftdot0.get_bits_UR())
        LD = []
        LD.append(self.leftdot2.get_bits_LD())
        LD.append(self.leftdot1.get_bits_LD())
        LD.append(self.leftdot0.get_bits_LD())
        return ''.join(str(n)for n in (V+LU+DR+UR+LD))

    def cpy(self):
        #window.clipboard_clear()
        s = self.get_bits()
        self.label_bit.config(text="Current Bitstream:"+s)
        #window.clipboard_append(s)

#window = tk.Tk()
#cblock = Cblock2(window)
#window.mainloop()
