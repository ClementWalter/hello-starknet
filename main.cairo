%builtins range_check

from starkware.cairo.common.math_cmp import is_le, is_nn

func main{range_check_ptr}() {
    is_nn(0 - 1);
    return ();
}
