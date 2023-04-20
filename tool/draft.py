a = True
b = False
c = True
d = True
eq_str = "a and b or c or d"
def evaluate_boolean_eqn(eq_str):
    inputs = [False, True]
    output = []
    for a in inputs:
        for b in inputs:
            for c in inputs:
                for d in inputs:
                    val = eval(eq_str)
                    output.append(val)
    output = [int(n) for n in output]
    return output

print(len(evaluate_boolean_eqn(eq_str)))
print((evaluate_boolean_eqn(eq_str)))