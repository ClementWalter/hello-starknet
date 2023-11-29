from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem

from array import reverse

func felt_to_ascii{range_check_ptr}(n: felt) -> (ascii_len: felt, ascii: felt*) {
    alloc_locals;
    let (local ascii: felt*) = alloc();

    tempvar range_check_ptr = range_check_ptr;
    tempvar n = n;
    tempvar ascii_len = 0;

    body:
    let ascii = cast([fp], felt*);
    let range_check_ptr = [ap - 3];
    let n = [ap - 2];
    let ascii_len = [ap - 1];

    let (n, digit) = unsigned_div_rem(n, 10);
    assert [ascii + ascii_len] = digit + '0';

    tempvar range_check_ptr = range_check_ptr;
    tempvar n = n;
    tempvar ascii_len = ascii_len + 1;

    jmp body if n != 0;

    let range_check_ptr = [ap - 3];
    let ascii_len = [ap - 1];
    let ascii = cast([fp], felt*);

    let (ascii) = reverse(ascii_len, ascii);

    return (ascii_len, ascii);
}


func test_felt_to_ascii_zero{range_check_ptr}() {

    let (ascii_len, ascii) = felt_to_ascii(0);

    assert ascii_len = 1;
    assert [ascii] = '0';

    return ();
}

func test_felt_to_ascci_not_zero{range_check_ptr}() {
    let (ascii_len, ascii) = felt_to_ascii(1234);

    assert ascii_len = 4;
    assert [ascii] = '1';
    assert [ascii + 1] = '2';
    assert [ascii + 2] = '3';
    assert [ascii + 3] = '4';

    return ();
}
