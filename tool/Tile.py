import tkinter as tk
import CLB
import Cblock
import Sblock

window = tk.Tk()
frame1 = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
frame1.pack()
frame2 = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
frame2.pack()
frame3 = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
frame3.pack()
frame4 = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
frame4.pack()

clb0 = CLB.LUT(frame1)
cblock0 = Cblock.Cblock(frame2)
sblock0 = Sblock.Sblock(frame3)
cblock1 = Cblock.Cblock(frame4)

window.mainloop()

