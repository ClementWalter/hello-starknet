func only_ap():
    [ap] = 100; ap++
    [ap] = [ap - 1] * [ap - 1]; ap++
    [ap] = [ap - 1] * [ap - 2]; ap++
    [ap] = [ap - 2] * 23; ap++
    [ap] = [ap - 4] * 45; ap++
    [ap] = [ap - 1] + 67; ap++
    [ap] = [ap - 1] + [ap - 3]; ap++
    [ap] = [ap - 1] + [ap - 5]
    ret
end

func only_fp():
    [ap] = 100; ap++  # x
    [ap] = [fp] * [fp]; ap++  # x^2
    [ap] = [fp + 1] * [fp]; ap++  # x^3
    [ap] = [fp + 1] * 23; ap++  # x^2 * 23
    [ap] = [fp] * 45; ap++  # x * 45
    [ap] = [fp + 4] + 67; ap++  # x * 45 + 67
    [ap] = [fp + 3] + [fp + 5]; ap++  # x^2 * 23 + x * 45 + 67
    [ap] = [fp + 6] + [fp + 2]
    ret
end

func only_5():
    # write as x(x(x + 23) + 45) + 67
    [ap] = 100; ap++  # x
    [ap] = [ap - 1] + 23; ap++  # x + 23
    [ap] = [ap - 2] * [ap - 1]; ap++  # x(x + 23)
    [ap] = [ap - 1] + 45; ap++  # x(x + 23) + 45
    [ap] = [ap - 1] * [fp]; ap++  # x(x(x + 23) + 45)
    [ap] = [ap - 1] + 67; ap++  # x(x(x + 23) + 45) + 67
    ret
end

func using_tempvar():
    tempvar x = 100
    tempvar y = x * x * x + 23 * x * x + 45 * x + 67
    ret
end

func main():
    using_tempvar()
    ret
end
