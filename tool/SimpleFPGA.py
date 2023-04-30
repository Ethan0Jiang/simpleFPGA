import tkinter as tk
import Tile

class SimpleFPGA:
    def __init__(self, master, size):
        self.vscroll = tk.Scrollbar(master=master, orient=tk.VERTICAL)
        self.vscroll.pack(side = tk.RIGHT, fill = tk.Y)
        self.hscroll = tk.Scrollbar(master=master, orient=tk.HORIZONTAL)
        self.hscroll.pack(side = tk.BOTTOM, fill = tk.X)
        self.canvaswrapper = tk.Canvas(master=master, height=1000,width=1600,yscrollcommand=self.vscroll.set,xscrollcommand=self.hscroll.set)
        self.gridmaster = tk.Frame(master=self.canvaswrapper)

        self.tile = []
        for j in range(size):
            for i in range(size):
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


window = tk.Tk()
simple = SimpleFPGA(window,3)
window.mainloop()
