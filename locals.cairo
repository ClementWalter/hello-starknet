func locals_wrong_order{output_ptr : felt*}():
    let x = [ap + 1]
    [ap + 1] = 0

    local y
    ap += SIZEOF_LOCALS
    y = 6
    %{
        print(f"x: {ids.x}")    
        print(f"y: {ids.y}")
    %}
    ret
end

func pow4(n) -> (m : felt):
    alloc_locals
    local x

    jmp body if n != 0
    x = 0
    ret

    body:
    x = n * n
    [ap] = x * x; ap++
    ret
end

func main():
    # locals_wrong_order()
    pow4(n=0)
    ret
end
