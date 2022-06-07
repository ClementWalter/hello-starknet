%builtins output

func main{output_ptr : felt*}():
    alloc_locals
    local x : felt
    %{
        from sympy import Poly, FiniteField
        from sympy.abc import x

        F = FiniteField(PRIME)
        p = Poly(x**7 + x + 18, domain=F)
        ids.x = int(list(p.ground_roots().keys())[0])
    %}
    assert x * x * x * x * x * x * x + x + 18 = 0

    return ()
end
