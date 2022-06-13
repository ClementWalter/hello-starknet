func main():
    # Call prod(1, 1, 10).
    [ap] = 2; ap++
    [ap] = 1; ap++
    [ap] = 7; ap++
    call prod

    # Make sure the 10th Fibonacci number is 2^7.
    assert [ap - 1] = 128
    ret
end

func prod(x, cum_prod, n) -> (res : felt):
    jmp body if n != 0
    [ap] = cum_prod; ap++
    ret

    body:
    [ap] = x; ap++
    [ap] = x * cum_prod; ap++
    [ap] = n - 1; ap++
    call prod
    ret
end
