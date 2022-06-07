%builtins output

func main{output_ptr : felt*}():
    alloc_locals
    local x : felt
    %{ ids.x = 1170844190292009568001808803857454672730461601705603861268203646905789841551 %}
    assert x * x * x * x * x * x * x + x + 18 = 0

    return ()
end
