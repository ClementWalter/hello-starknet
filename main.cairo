%builtins range_check

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_read, dict_write

from print import print_uint256, print_array, print_dict


func main{range_check_ptr}() {
    alloc_locals;

    tempvar value = new Uint256(1, 3);
    let (dict_ptr) = default_dict_new(0);
    with dict_ptr {
        dict_read(0);
        dict_read(1);
        dict_read(1);
        dict_write(2, cast(value, felt));
        dict_read(2);
    }

    print_dict('dict_name', dict_ptr, Uint256.SIZE);

    return ();
}
