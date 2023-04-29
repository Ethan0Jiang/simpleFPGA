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

    #def __init__(self, master):
    #    self.vscroll = tk.Scrollbar(master=master, orient=tk.VERTICAL)
    #    self.vscroll.pack(side = tk.RIGHT, fill = tk.Y)
    #    self.hscroll = tk.Scrollbar(master=master, orient=tk.HORIZONTAL)
    #    self.hscroll.pack(side = tk.BOTTOM, fill = tk.X)
    #    self.canvaswrapper = tk.Canvas(master=master, height=1000,width=1600,yscrollcommand=self.vscroll.set,xscrollcommand=self.hscroll.set)
    #    self.gridmaster = tk.Frame(master=self.canvaswrapper)
    #    self.frame0 = tk.Frame(master=self.gridmaster, relief=tk.RAISED, borderwidth=1)
    #    self.tile0 = Tile.Tile(self.frame0)
    #    self.frame0.grid(row=0, column=0)
    #    self.frame1 = tk.Frame(master=self.gridmaster, relief=tk.RAISED, borderwidth=1)
    #    self.tile1 = Tile.Tile(self.frame1)
    #    self.frame1.grid(row=0, column=1)
    #    self.frame2 = tk.Frame(master=self.gridmaster, relief=tk.RAISED, borderwidth=1)
    #    self.tile2 = Tile.Tile(self.frame2)
    #    self.frame2.grid(row=1, column=0)
    #    self.frame3 = tk.Frame(master=self.gridmaster, relief=tk.RAISED, borderwidth=1)
    #    self.tile3 = Tile.Tile(self.frame3)
    #    self.frame3.grid(row=1, column=1)

    #    self.canvaswrapper.create_window(0,0,window=self.gridmaster, anchor="nw")
    #    self.canvaswrapper.pack(expand=True, fill=tk.BOTH)
    #    master.update()
    #    self.canvaswrapper.configure(scrollregion = self.canvaswrapper.bbox("all"))
    #    self.vscroll.config(command=self.canvaswrapper.yview)
    #    self.hscroll.config(command=self.canvaswrapper.xview)

window = tk.Tk()
simple = SimpleFPGA(window,3)
window.mainloop()
