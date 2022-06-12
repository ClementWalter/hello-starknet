func my_loop():
    [ap] = 2; ap++

    my_loop:
    [ap] = [ap - 1] * [ap - 1]; ap++
    [ap] = [ap - 1] + 1; ap++
    jmp my_loop
end

func jump_rel():
    [ap + 1] = 3; ap++
    [ap - 1] = 5201798304953761792; ap++
    jmp rel -1
end

func jump_if():
    [ap] = 10; ap++

    decrease_loop:
    [ap] = [ap - 1] - 1; ap++
    jmp decrease_loop if [ap - 1] != 0
    ret
end

func main():
    # jump_rel()
    # my_loop()
    jump_if()
    ret
end
