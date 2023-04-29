import tkinter as tk

class LUT:
    def __init__(self, master):
        self.o_sel_bits = [0,0,0,0]
        self.mux_sel_bits = [1]  # 1:lut, 0:ff
        self.ff_en_bits = [1,0]
        self.lut_bits = [0]*16

        self.frame_canvas = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )

        self.frame_bool = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )

        self.frame_bits = tk.Frame(
             master=master,
             relief=tk.RAISED,
             borderwidth=1
            )

        # create a canvas for drawing the CLB block
        self.frame_canvas.grid(row=0, column=0)
        self.canvas = tk.Canvas(master = self.frame_canvas, width=400, height=160)
        self.canvas.pack()

        self.frame_bool.grid(row=1, column=0)
        self.entry = tk.Entry(master = self.frame_bool)
        Calculate = tk.Button(master=self.frame_bool, text="Calculate", command=self.togglekeep)
        self.entry.pack(fill=tk.Y, side=tk.LEFT)
        Calculate.pack(fill=tk.Y, side=tk.LEFT)

        self.frame_bits.grid(row=2, column=0)
        self.label = tk.Label(master = self.frame_bits, text="Current Bitstream: 00001100000000000000000")
        self.label.pack()




        # draw the LUT block
        self.lut_block = self.canvas.create_rectangle(10, 10, 100, 140, fill='white')
        self.canvas.create_text(55, 20, text='4-Input LUT')
        luts = []
        port_position = ["U","D","R","L"]
        for i in range(4):
            lut = self.canvas.create_rectangle(20, 20*i+40, 50, 20*i+60, fill='white')
            self.canvas.move(lut, -10, 0)
            txt_in = self.canvas.create_text(30, 20*i+50, text='IN_{}'.format(port_position[i]))
            self.canvas.move(txt_in, -5, 0)
            luts.append(lut)
        lut_output = self.canvas.create_rectangle(55, 40, 100, 60, fill='white')
        self.canvas.create_text(80, 50, text='LUT_O')

        # draw the FF block
        self.ff_block = self.canvas.create_rectangle(130, 60, 240, 140, fill='white')
        self.canvas.create_text(195, 70, text='Flip-Flop')
        self.FF_ins = []
        self.FF_clr = []
        port_position = ["U","1","R","L"]
        for i in range(4):
            ff_color = self.canvas.create_rectangle(130, 20*i+60, 160, 20*i+80, fill='lightgray')
            txt_ff = self.canvas.create_text(145, 20*i+70, text='IN_{}'.format(port_position[i]))
            self.FF_ins.append(txt_ff)
            self.FF_clr.append(ff_color)
        self.ff_output = self.canvas.create_rectangle(200, 80, 240, 100, fill='white')
        self.txt_ff_out = self.canvas.create_text(220, 90, text='FF_OUT')
        for i in range(len(self.FF_ins)):
            self.canvas.tag_bind(self.FF_ins[i], '<Button-1>', lambda event,
                                item=self.FF_clr[i], value=i: self.toggle_mux_en(item, value))

        # draw the MUX block
        mux_block = self.canvas.create_rectangle(290, 10, 380, 140, fill='white')
        self.canvas.create_text(335, 20, text='2-Input MUX')
        self.mux_input_lut = self.canvas.create_rectangle(290, 40, 315, 60, fill='green')
        self.canvas.create_text(301, 50, text='LUT')
        self.mux_input_ff = self.canvas.create_rectangle(290, 80, 315, 100, fill='white')
        self.canvas.create_text(301, 90, text='FF')
        sel = self.canvas.create_rectangle(290, 60, 315, 80, fill='lightgray')
        self.sel_text = self.canvas.create_text(301, 70, text='SEL')

        self.MUX_ins = []
        self.MUX_clr = []
        port_position = ["U","D","R","L"]
        for i in range(4):
            mux_color = self.canvas.create_rectangle(355, 20*i+40, 380, 20*i+60, fill='lightgray')
            txt_o = self.canvas.create_text(368, 20*i+50, text='O_{}'.format(port_position[i]))
            self.MUX_ins.append(txt_o)
            self.MUX_clr.append(mux_color)
        for i in range(len(self.MUX_ins)):
            self.canvas.tag_bind(self.MUX_ins[i], '<Button-1>', lambda event,
                                item=self.MUX_clr[i], value=i: self.toggle_output(item, value))  # select which output enable
        self.canvas.tag_bind(self.sel_text, '<Button-1>', self.toggle_mux_inputs)  # select mux input


    def togglekeep(self):
        #s = self.o_sel_bits + self.mux_sel_bits + self.ff_en_bits + self.lut_bits
        equation = self.entry.get()
        self.lut_bits = self.evaluate_boolean_eqn(equation)
        #s = self.get_bits()
        #s_string = ''.join(str(x) for x in s)
        s_string = self.get_bits()

        self.label.config(text="Current Bitstream: "+s_string)
        #window.clipboard_clear()
        #window.clipboard_append(s_string)



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



    def get_bits(self):
        bits = []
        bits.extend(self.o_sel_bits)
        bits.extend(self.mux_sel_bits)
        bits.extend(self.ff_en_bits)
        bits.extend(self.lut_bits)
        bits_string = ''.join(str(x) for x in bits)
        return bits_string

    def toggle_output(self, item, value):
        current_color = self.canvas.itemcget(item, 'fill')
        if current_color == 'green':
            self.canvas.itemconfigure(item, fill='lightgray')
        else:
            self.canvas.itemconfigure(item, fill='green')
        current_bits = self.o_sel_bits[value]
        if current_bits == 1:
            self.o_sel_bits[value] = 0
        else:
            self.o_sel_bits[value] = 1


    def toggle_mux_en(self, item, value):  # ["U","1","R","L"]
        current_color = self.canvas.itemcget(item, 'fill')
        if current_color == 'green':
            self.canvas.itemconfigure(item, fill='lightgray')
        else:
            self.canvas.itemconfigure(item, fill='green')
            if value == 0:
                self.ff_en_bits = [1,1]
            elif value == 1:
                self.ff_en_bits = [1,0]
            elif value == 2:
                self.ff_en_bits = [0,1]
            elif value == 3:
                self.ff_en_bits = [0,0]


    def toggle_mux_inputs(self, event):
        current_color = self.canvas.itemcget(self.mux_input_lut, 'fill')
        if current_color == 'green':
            self.canvas.itemconfigure(self.mux_input_lut, fill='white')
            self.canvas.itemconfigure(self.mux_input_ff, fill='green')
        else:
            self.canvas.itemconfigure(self.mux_input_lut, fill='green')
            self.canvas.itemconfigure(self.mux_input_ff, fill='white')

        current_bits = self.mux_sel_bits[0]
        if current_bits == 1:
            self.mux_sel_bits[0] = 0
        else:
            self.mux_sel_bits[0] = 1

    # def update_mux_sel_bits(self):
    #     current_bits = self.mux_sel_bits[0]
    #     if current_bits == 1:
    #         self.mux_sel_bits[0] = 0
    #     else:
    #         self.mux_sel_bits[0] = 1

#window = tk.Tk()
#updot0 = LUT(window)
#window.mainloop()
