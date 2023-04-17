import tkinter as tk

window = tk.Tk()
framelist = []
canvasdict = {}
Hval = [1,1,1,1,1,1,1,1,1]
Vval = [1,1,1,1,1,1,1,1,1]
Hlist = []
Vlist = []

def draw_1():
    Vval[8] = 1 - Vval[8]
    Vval[7] = 1 - Vval[7]
    Vval[6] = 1 - Vval[6]
    s = ''.join(str(n)for n in (Hval[::-1]+Vval[::-1]))
    label_bit.config(text="Current Bitstream:"+s)
    if Vval[8] == 0:
        tk.Canvas.itemconfig(canvasdict[6], Vlist[8], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[6], Vlist[8], fill="red")
    if Vval[7] == 0:
        tk.Canvas.itemconfig(canvasdict[11], Vlist[7], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[11], Vlist[7], fill="red")
    if Vval[6] == 0:
        tk.Canvas.itemconfig(canvasdict[16], Vlist[6], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[16], Vlist[6], fill="red")
def draw_2():
    Vval[5] = 1 - Vval[5]
    Vval[4] = 1 - Vval[4]
    Vval[3] = 1 - Vval[3]
    s = ''.join(str(n)for n in (Hval[::-1]+Vval[::-1]))
    label_bit.config(text="Current Bitstream:"+s)
    if Vval[5] == 0:
        tk.Canvas.itemconfig(canvasdict[7], Vlist[5], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[7], Vlist[5], fill="red")
    if Vval[4] == 0:
        tk.Canvas.itemconfig(canvasdict[12], Vlist[4], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[12], Vlist[4], fill="red")
    if Vval[3] == 0:
        tk.Canvas.itemconfig(canvasdict[17], Vlist[3], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[17], Vlist[3], fill="red")
def draw_3():
    Vval[2] = 1 - Vval[2]
    Vval[1] = 1 - Vval[1]
    Vval[0] = 1 - Vval[0]
    s = ''.join(str(n)for n in (Hval[::-1]+Vval[::-1]))
    label_bit.config(text="Current Bitstream:"+s)
    if Vval[2] == 0:
        tk.Canvas.itemconfig(canvasdict[8], Vlist[2], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[8], Vlist[2], fill="red")
    if Vval[1] == 0:
        tk.Canvas.itemconfig(canvasdict[13], Vlist[1], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[13], Vlist[1], fill="red")
    if Vval[0] == 0:
        tk.Canvas.itemconfig(canvasdict[18], Vlist[0], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[18], Vlist[0], fill="red")
def draw_5():
    Hval[8] = 1 - Hval[8]
    Hval[7] = 1 - Hval[7]
    Hval[6] = 1 - Hval[6]
    s = ''.join(str(n)for n in (Hval[::-1]+Vval[::-1]))
    label_bit.config(text="Current Bitstream:"+s)
    if Hval[8] == 0:
        tk.Canvas.itemconfig(canvasdict[6], Hlist[8], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[6], Hlist[8], fill="blue")
    if Hval[7] == 0:
        tk.Canvas.itemconfig(canvasdict[7], Hlist[7], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[7], Hlist[7], fill="blue")
    if Hval[6] == 0:
        tk.Canvas.itemconfig(canvasdict[8], Hlist[6], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[8], Hlist[6], fill="blue")
def draw_10():
    Hval[5] = 1 - Hval[5]
    Hval[4] = 1 - Hval[4]
    Hval[3] = 1 - Hval[3]
    s = ''.join(str(n)for n in (Hval[::-1]+Vval[::-1]))
    label_bit.config(text="Current Bitstream:"+s)
    if Hval[5] == 0:
        tk.Canvas.itemconfig(canvasdict[11], Hlist[5], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[11], Hlist[5], fill="blue")
    if Hval[4] == 0:
        tk.Canvas.itemconfig(canvasdict[12], Hlist[4], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[12], Hlist[4], fill="blue")
    if Hval[3] == 0:
        tk.Canvas.itemconfig(canvasdict[13], Hlist[3], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[13], Hlist[3], fill="blue")
def draw_15():
    Hval[2] = 1 - Hval[2]
    Hval[1] = 1 - Hval[1]
    Hval[0] = 1 - Hval[0]
    s = ''.join(str(n)for n in (Hval[::-1]+Vval[::-1]))
    label_bit.config(text="Current Bitstream:"+s)
    if Hval[2] == 0:
        tk.Canvas.itemconfig(canvasdict[16], Hlist[2], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[16], Hlist[2], fill="blue")
    if Hval[1] == 0:
        tk.Canvas.itemconfig(canvasdict[17], Hlist[1], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[17], Hlist[1], fill="blue")
    if Hval[0] == 0:
        tk.Canvas.itemconfig(canvasdict[18], Hlist[0], fill="white")
    else:
        tk.Canvas.itemconfig(canvasdict[18], Hlist[0], fill="blue")

draw = {}
draw[1] = draw_1
draw[2] = draw_2
draw[3] = draw_3
draw[5] = draw_5
draw[10] = draw_10
draw[15] = draw_15

for i in range(5):
    window.columnconfigure(i, weight=1, minsize=75)
    window.rowconfigure(i, weight=1, minsize=50)

    for j in range(5):
        frame = tk.Frame(
            master=window,
            relief=tk.RAISED,
            borderwidth=1
        )
        framelist.append(frame)
        frame.grid(row=i, column=j, padx=5, pady=5)

s = ''.join(str(n)for n in (Hval[::-1]+Vval[::-1]))
label_bit = tk.Label(master=window, text="Current Bitstream:"+s)
label_bit.grid(row=5, columnspan=5)

def cpy():
    window.clipboard_clear()
    s = ''.join(str(n)for n in (Hval[::-1]+Vval[::-1]))
    window.clipboard_append(s)
copy_btn = tk.Button(master=window, text="Copy", command=cpy)
copy_btn.grid(row=6, column=2)

#cornerlist = [0, 4, 20, 24]
for i in [0,4,20,24]:
    framelist[i]["borderwidth"] = 0

ilist = [1, 2, 3, 5, 10, 15]
olist = [9,14, 19, 21, 22, 23]
for i in ilist:
    button = tk.Button(master=framelist[i], text="in", command=draw[i])
    button.pack()
for i in olist:
    label = tk.Label(master=framelist[i], text="out")
    label.pack(padx=5, pady=5)

buflist = [6, 7, 8, 11, 12, 13, 16, 17, 18]
for i in buflist:
    canvas = tk.Canvas(master=framelist[i], height=50, width=75)
    Harrow = canvas.create_line(5,25,65,25, fill='blue', arrow='last', width=4)
    Hlist.insert(0,Harrow)
    canvasdict[i] = canvas
    canvas.pack()
for i in [6,11,16,7,12,17,8,13,18]:
    canvas = canvasdict[i]
    Varrow = canvas.create_line(37,5,37,45, fill='red', arrow='last', width=4)
    Vlist.insert(0,Varrow)
    canvas.pack()

window.mainloop()
