%builtins output range_check

from starkware.cairo.common.serialize import serialize_word

func scope(n):
    if n == 0:
        return ()
    end

    alloc_locals
    local a
    %{
        if "b" not in dir():
            b = 0
        b += 1
        print(b)
    %}
    return scope(n=n - 1)
end

func main{output_ptr : felt*, range_check_ptr}():
    scope(n=10)
    return ()
end
