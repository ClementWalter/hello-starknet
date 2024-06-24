from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le, is_nn

func reverse(arr_len: felt, arr: felt*) -> (arr_len: felt, arr: felt*) {
    alloc_locals;

    if (arr_len == 0) {
        return (arr_len, arr);
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

    let arr = cast([fp], felt*);
    return (arr_len, arr);
}

func add_one(arr_len: felt, arr: felt*) -> (arr_len: felt, arr: felt*) {
    alloc_locals;

    if (arr_len == 0) {
        return (arr_len, arr);
    }

    let (local arr2: felt*) = alloc();
    tempvar i = arr_len;

    body:
    let i = [ap - 1];

    let arr_len = [fp - 4];
    let arr = cast([fp - 3], felt*);
    let arr2 = cast([fp], felt*);

    assert [arr2 + i - 1] = [arr + i - 1] + 1;
    tempvar i = i - 1;

    jmp body if i != 0;

    let arr = cast([fp], felt*);
    return (arr_len, arr);
}

func sum(arr_len: felt, arr: felt*) -> felt {
    alloc_locals;

    tempvar sum = 0;
    tempvar i = arr_len;

    body:
    let arr_len = [fp - 4];
    let arr = cast([fp - 3], felt*);
    let sum = [ap - 2];
    let i = [ap - 1];

    tempvar sum = sum + [arr + i - 1];
    tempvar i = i - 1;

    jmp body if i != 0;

    return sum;
}

func main() {
    let arr_len = 4;
    let (arr) = alloc();
    assert [arr] = 1;
    assert [arr + 1] = 2;
    assert [arr + 2] = 3;
    assert [arr + 3] = 4;

    [ap] = arr_len, ap++;
    [ap] = arr, ap++;
    call reverse;
    call add_one;
    call sum;

    return ();
}
