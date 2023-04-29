import tkinter as tk
import CLB
import Cblock
import Cblock2
import Sblock

class Tile:
    def __init__(self, master):
        self.clbframe = tk.Frame(master=master, relief=tk.RAISED, borderwidth=1)
        self.cframe0 = tk.Frame(master=master, relief=tk.RAISED, borderwidth=1)
        self.cframe1 = tk.Frame(master=master, relief=tk.RAISED, borderwidth=1)
        self.sframe = tk.Frame(master=master, relief=tk.RAISED, borderwidth=1)

        self.clb = CLB.LUT(self.clbframe)
        self.cblock0 = Cblock.Cblock(self.cframe0)
        self.cblock1 = Cblock2.Cblock2(self.cframe1)
        self.sblock = Sblock.Sblock(self.sframe)
        self.clbframe.grid(row=0, column=0)
        self.cframe0.grid(row=1, column=0)
        self.cframe1.grid(row=0, column=1)
        self.sframe.grid(row=1, column=1)
        self.gen_btn = tk.Button(master=master, text="generate", command=self.generate)
        self.gen_btn.grid(row=2,columnspan=2)
        self.label_bit = tk.Label(master=master, text="Current Bitstream:")
        self.label_bit.grid(row=3, columnspan=2)

    def generate(self):
        self.cblock0.cpy()
        self.cblock1.cpy()
        self.sblock.generate()
        self.clb.togglekeep()
        s = self.get_bits()
        self.label_bit.config(text="Current Bitstream:"+s)
        #window.clipboard_clear()
        #window.clipboard_append(s)

    def get_bits(self):
        return self.clb.get_bits()+self.cblock0.get_bits()+self.cblock1.get_bits()+self.sblock.get_bits()


#window = tk.Tk()
#tile = Tile(window)
#window.mainloop()

