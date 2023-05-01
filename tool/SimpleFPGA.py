import tkinter as tk
import Tile

class SimpleFPGA:
    def __init__(self, master, size):
        self.master = master
        self.size = size
        self.vscroll = tk.Scrollbar(master=master, orient=tk.VERTICAL)
        self.vscroll.pack(side = tk.RIGHT, fill = tk.Y)
        self.hscroll = tk.Scrollbar(master=master, orient=tk.HORIZONTAL)
        self.hscroll.pack(side = tk.BOTTOM, fill = tk.X)
        self.canvaswrapper = tk.Canvas(master=master, height=1000,width=1600,yscrollcommand=self.vscroll.set,xscrollcommand=self.hscroll.set)
        self.gridmaster = tk.Frame(master=self.canvaswrapper)

        self.tile = []
        for i in range(size):
            for j in range(size):
                fm = tk.Frame(master=self.gridmaster, relief=tk.RAISED, borderwidth=1)
                t = Tile.Tile(fm)
                self.tile.append(t)
                fm.grid(row=j, column=i) #careful

        self.canvaswrapper.create_window(0,0,window=self.gridmaster, anchor="nw")
        self.canvaswrapper.pack(expand=True, fill=tk.BOTH)
        master.update()
        self.canvaswrapper.configure(scrollregion = self.canvaswrapper.bbox("all"))
        self.vscroll.config(command=self.canvaswrapper.yview)
        self.hscroll.config(command=self.canvaswrapper.xview)
        self.canvaswrapper.bind_all("<Left>",  lambda event: self.canvaswrapper.xview_scroll(-1, "units"))
        self.canvaswrapper.bind_all("<Right>",  lambda event: self.canvaswrapper.xview_scroll(1, "units"))
        self.canvaswrapper.bind_all("<Up>",  lambda event: self.canvaswrapper.yview_scroll(-1, "units"))
        self.canvaswrapper.bind_all("<Down>",  lambda event: self.canvaswrapper.yview_scroll(1, "units"))
        self.canvaswrapper.bind_all("<MouseWheel>",  lambda event: self.canvaswrapper.yview_scroll(-1*(event.delta), "units"))
        self.canvaswrapper.bind_all("<Shift-MouseWheel>",  lambda event: self.canvaswrapper.xview_scroll(-1*(event.delta), "units"))
        self.canvaswrapper.bind_all("<Button-4>",  lambda event: self.canvaswrapper.yview_scroll(-1, "units"))
        self.canvaswrapper.bind_all("<Button-5>",  lambda event: self.canvaswrapper.yview_scroll(1, "units"))
        self.canvaswrapper.bind_all("<Shift-Button-4>",  lambda event: self.canvaswrapper.xview_scroll(-1, "units"))
        self.canvaswrapper.bind_all("<Shift-Button-5>",  lambda event: self.canvaswrapper.xview_scroll(1, "units"))

        self.menubar = tk.Menu(master = master)
        self.menu = tk.Menu(master = self.menubar, tearoff = 0)
        self.menu.add_command(label = "generate all", command = self.generate, accelerator = "Ctrl+g")
        self.menu.bind_all("<Control-g>", lambda event: self.generate)
        self.menubar.add_cascade(label="Action", menu=self.menu)
        master.config(menu = self.menubar)

    def generate(self):
        newWindow = tk.Toplevel(master = self.master)
        s = "Bitstream for testbench:\n"
        text = tk.Text(master = newWindow)
        text.pack()
        for i in range(self.size):
            for j in range(self.size-1,-1,-1): #reverse sequence for shift register
                self.tile[j+i*self.size].generate()
                s = s + self.tile[j+i*self.size].get_bits() + "\n"
            s = s + "full batch end(column) \n \n"
        text.insert(tk.END, s)


window = tk.Tk()
simple = SimpleFPGA(window,3)
window.mainloop()
