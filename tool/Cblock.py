import tkinter as tk

class dot_down:
    def __init__(self, master, row, column):
        self.bits = [0,0,0] # UR, LD, V
        self.frame = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )
        #self.frame.pack()
        self.frame.grid(row=row, column=column)
        self.canvas = tk.Canvas(master = self.frame, width=100, height=100)
        self.canvas.pack(side=tk.LEFT)
        self.UR = self.canvas.create_line(50,0,100,50, fill='white', arrow='last', width=4)
        self.LD = self.canvas.create_line(0,50,50,100, fill='white', arrow='last', width=4)
        self.V = self.canvas.create_line(50,0,50,100, fill='white', arrow='last', width=4)
        self.highway = self.canvas.create_line(0,50,100,50, fill='brown', arrow='last', width=6)
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
        s = get_bits()
        label_bit.config(text="Current Bitstream:"+s)

    def toggleexit(self):
        self.bits[1] = 1 - self.bits[1]
        if self.bits[1] == 1:
            self.canvas.itemconfig(self.LD, fill="blue")
        else:
            self.canvas.itemconfig(self.LD, fill="white")
        s = get_bits()
        label_bit.config(text="Current Bitstream:"+s)

    def togglekeep(self):
        self.bits[2] = 1 - self.bits[2]
        if self.bits[2] == 1:
            self.canvas.itemconfig(self.V, fill="blue")
        else:
            self.canvas.itemconfig(self.V, fill="white")
        s = get_bits()
        label_bit.config(text="Current Bitstream:"+s)

    def get_bits_UR(self):
        return self.bits[0]

    def get_bits_LD(self):
        return self.bits[1]

    def get_bits_V(self):
        return self.bits[2]

class dot_up:
    def __init__(self, master, row, column):
        self.bits = [0,0,0] # LU, DR, V
        self.frame = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )
        #self.frame.pack()
        self.frame.grid(row=row, column=column)
        self.canvas = tk.Canvas(master = self.frame, width=100, height=100)
        self.canvas.pack(side=tk.RIGHT)
        self.LU = self.canvas.create_line(0,50,50,0, fill='white', arrow='last', width=4)
        self.DR = self.canvas.create_line(50,100,100,50, fill='white', arrow='last', width=4)
        self.V = self.canvas.create_line(50,100,50,0, fill='white', arrow='last', width=4)
        self.highway = self.canvas.create_line(0,50,100,50, fill='brown', arrow='last', width=6)
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
        s = get_bits()
        label_bit.config(text="Current Bitstream:"+s)

    def togglemerge(self):
        self.bits[1] = 1 - self.bits[1]
        if self.bits[1] == 1:
            self.canvas.itemconfig(self.DR, fill="blue")
        else:
            self.canvas.itemconfig(self.DR, fill="white")
        s = get_bits()
        label_bit.config(text="Current Bitstream:"+s)

    def togglekeep(self):
        self.bits[2] = 1 - self.bits[2]
        if self.bits[2] == 1:
            self.canvas.itemconfig(self.V, fill="blue")
        else:
            self.canvas.itemconfig(self.V, fill="white")
        s = get_bits()
        label_bit.config(text="Current Bitstream:"+s)

    def get_bits_LU(self):
        return self.bits[0]

    def get_bits_DR(self):
        return self.bits[1]

    def get_bits_V(self):
        return self.bits[2]

window = tk.Tk()
updot0 = dot_up(window,0,0)
updot1 = dot_up(window,1,0)
updot2 = dot_up(window,2,0)
downdot0 = dot_down(window,0,1)
downdot1 = dot_down(window,1,1)
downdot2 = dot_down(window,2,1)

def get_bits():
    V = []
    V.append(updot2.get_bits_V())
    V.append(updot1.get_bits_V())
    V.append(updot0.get_bits_V())
    V.append(downdot0.get_bits_V())
    V.append(downdot1.get_bits_V())
    V.append(downdot2.get_bits_V())
    LU = []
    LU.append(updot0.get_bits_LU())
    LU.append(updot1.get_bits_LU())
    LU.append(updot2.get_bits_LU())
    DR = []
    DR.append(updot0.get_bits_DR())
    DR.append(updot1.get_bits_DR())
    DR.append(updot2.get_bits_DR())
    UR = []
    UR.append(downdot0.get_bits_UR())
    UR.append(downdot1.get_bits_UR())
    UR.append(downdot2.get_bits_UR())
    LD = []
    LD.append(downdot0.get_bits_LD())
    LD.append(downdot1.get_bits_LD())
    LD.append(downdot2.get_bits_LD())
    return ''.join(str(n)for n in (V+LU+DR+UR+LD))

label_bit = tk.Label(master=window, text="Current Bitstream:000000000000000000")
label_bit.grid(row=3, columnspan=2)

def cpy():
    window.clipboard_clear()
    s = get_bits()
    window.clipboard_append(s)

copy_btn = tk.Button(master=window, text="copy", command=cpy)
copy_btn.grid(row=4, columnspan=2)

window.mainloop()
