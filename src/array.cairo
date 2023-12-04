from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_not_zero, is_nn
from starkware.cairo.common.bool import FALSE

func reverse(arr_len: felt, arr: felt*) -> (rev: felt*) {
    alloc_locals;

    if (arr_len == 0) {
        return (rev=arr);
    }

    let (local rev: felt*) = alloc();
    tempvar i = arr_len;

    body:
    let arr_len = [fp - 4];
    let arr = cast([fp - 3], felt*);
    let rev = cast([fp], felt*);
    let i = [ap - 1];

    assert [rev + i - 1] = [arr + arr_len - i];
    tempvar i = i - 1;

    jmp body if i != 0;

    let rev = cast([fp], felt*);
    return (rev=rev);
}

func count_not_zero(arr_len: felt, arr: felt*) -> felt {
    if (arr_len == 0) {
        return 0;
    }

    tempvar len = arr_len;
    tempvar count = 0;
    tempvar arr = arr;

    body:
    let len = [ap - 3];
    let count = [ap - 2];
    let arr = cast([ap - 1], felt*);
    let not_zero = is_not_zero([arr]);

    tempvar len = len - 1;
    tempvar count = count + not_zero;
    tempvar arr = arr + 1;

    jmp body if len != 0;

    let count = [ap - 2];

    return count;
}

// @notice Fills slice with a slice of data.
// @dev If the slice is out of bounds, the function pads with zeros.
func slice{range_check_ptr}(slice: felt*, data_len: felt, data: felt*, offset: felt, size: felt) {
    alloc_locals;

    if (size == 0) {
        return ();
    }

    let overlap = is_nn(data_len - offset);
    if (overlap == FALSE) {
        memset(dst=slice, value=0, n=size);
        return ();
    }

    let max_len = (data_len - offset);
    let is_within_bound = is_nn(max_len - size);
    if (is_within_bound != FALSE) {
        memcpy(dst=slice, src=data + offset, len=size);
        return ();
    }

    memcpy(dst=slice, src=data + offset, len=max_len);
    memset(dst=slice + max_len, value=0, n=size - max_len);
    return ();
}

namespace Tests {
    namespace CountNotZero {
        func test_should_return_count() {
            alloc_locals;

            let (arr: felt*) = alloc();
            assert [arr] = 0;
            assert [arr + 1] = 1;
            assert [arr + 2] = 2;
            assert [arr + 3] = 0;

            let count = count_not_zero(4, arr);
            assert count = 2;

            return ();
        }

        func test_should_handle_empty_array() {
            alloc_locals;

            let (arr: felt*) = alloc();
            let count = count_not_zero(0, arr);
            assert count = 0;

            return ();
        }
    }

    namespace Reverse {
        func test_should_handle_empty_array() {
            alloc_locals;

            let (arr: felt*) = alloc();

            let (rev) = reverse(0, arr);

            return ();
        }

        func test_should_reverse() {
            alloc_locals;

            let (arr: felt*) = alloc();
            assert [arr] = 1;
            assert [arr + 1] = 2;
            assert [arr + 2] = 3;

            let (rev) = reverse(3, arr);

            assert [rev] = 3;
            assert [rev + 1] = 2;
            assert [rev + 2] = 1;

            return ();
        }
    }

    namespace Slice {
        func test_should_handle_out_of_bounds{range_check_ptr}() {
            alloc_locals;

            let (arr: felt*) = alloc();
            let (sliced: felt*) = alloc();
            slice(sliced, 0, arr, 10, 5);

            assert [sliced] = 0;
            assert [sliced + 1] = 0;
            assert [sliced + 2] = 0;
            assert [sliced + 3] = 0;
            assert [sliced + 4] = 0;

            return ();
        }
        func test_should_slice_in_bounds{range_check_ptr}() {
            alloc_locals;

            let (arr: felt*) = alloc();

            assert [arr] = 0;
            assert [arr + 1] = 1;
            assert [arr + 2] = 2;
            assert [arr + 3] = 3;
            assert [arr + 4] = 4;

            let (sliced: felt*) = alloc();
            slice(sliced, 5, arr, 1, 2);

            assert [sliced] = 1;
            assert [sliced + 1] = 2;

            return ();
        }
        func test_should_slice_and_pad{range_check_ptr}() {
            alloc_locals;

            let (arr: felt*) = alloc();

            assert [arr] = 0;
            assert [arr + 1] = 1;
            assert [arr + 2] = 2;
            assert [arr + 3] = 3;
            assert [arr + 4] = 4;

            let (sliced: felt*) = alloc();
            slice(sliced, 5, arr, 3, 5);

            assert [sliced] = 3;
            assert [sliced + 1] = 4;
            assert [sliced + 2] = 0;
            assert [sliced + 3] = 0;
            assert [sliced + 4] = 0;

            return ();
        }
    }
}
