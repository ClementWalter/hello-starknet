from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.dict_access import DictAccess

func print_uint256(val: Uint256) {
    %{
        low = ids.val.low
        high = ids.val.high
        print(f"Uint256(low={low}, high={high}) = {2 ** 128 * high + low}")
    %}
    return ();
}

func print_array(name: felt, arr_len: felt, arr: felt*) {
    %{
        print(bytes.fromhex(f"{ids.name:062x}").decode().replace('\x00',''))
        arr = [memory[ids.arr + i] for i in range(ids.arr_len)]
        print(arr)
    %}
    return ();
}

func print_dict(name: felt, dict_ptr: DictAccess*, pointer_size: felt) {
    %{
        print(bytes.fromhex(f"{ids.name:062x}").decode().replace('\x00',''))
        data = __dict_manager.get_dict(ids.dict_ptr)
        print(
            {k: v if isinstance(v, int) else [memory[v + i] for i in range(ids.pointer_size)] for k, v in data.items()}
        )
    %}
    return ();
}
