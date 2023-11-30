from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_not_zero

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
}
