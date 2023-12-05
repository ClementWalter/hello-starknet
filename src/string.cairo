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

// @notice Split a felt into an array of bytes, little endian
// @dev Use a hint from split_int
func felt_to_bytes(value: felt) -> (bytes_len: felt, bytes: felt*) {
    alloc_locals;
    let (local bytes: felt*) = alloc();

    tempvar value = value;
    tempvar bytes_len = 0;

    body:
    let value = [ap - 2];
    let bytes_len = [ap - 1];
    let bytes = cast([fp], felt*);
    let output = bytes + bytes_len;
    let base = 2 ** 8;
    let bound = base;

    %{
        memory[ids.output] = res = (int(ids.value) % PRIME) % ids.base
        assert res < ids.bound, f'split_int(): Limb {res} is out of range.'
    %}
    let byte = [output];
    let value = (value - byte) / base;

    tempvar value = value;
    tempvar bytes_len = bytes_len + 1;

    jmp body if value != 0;

    let value = [ap - 2];
    let bytes_len = [ap - 1];
    assert value = 0;

    let bytes = cast([fp], felt*);

    return (bytes_len, bytes);
}

namespace Tests {
    namespace FeltToAscii {
        func test_should_return_zero{range_check_ptr}() {
            let (ascii_len, ascii) = felt_to_ascii(0);

            assert ascii_len = 1;
            assert [ascii] = '0';

            return ();
        }

        func test_should_encode_1234{range_check_ptr}() {
            let (ascii_len, ascii) = felt_to_ascii(1234);

            assert ascii_len = 4;
            assert [ascii] = '1';
            assert [ascii + 1] = '2';
            assert [ascii + 2] = '3';
            assert [ascii + 3] = '4';

            return ();
        }
    }

    namespace FeltToBytes {
        func test_should_return_zero() {
            let (bytes_len, bytes) = felt_to_bytes(0);
            assert [bytes] = 0;

            return ();
        }

        func test_should_return_one() {
            let (bytes_len, bytes) = felt_to_bytes(1);
            assert [bytes] = 1;

            return ();
        }

        func test_should_split_little_endian() {
            let (bytes_len, bytes) = felt_to_bytes(0xeeff);
            assert [bytes] = 0xff;
            assert [bytes + 1] = 0xee;

            return ();
        }

        func test_should_split_with_leading_zeros() {
            let (bytes_len, bytes) = felt_to_bytes(0xeeff0000);
            assert [bytes] = 0;
            assert [bytes + 1] = 0;
            assert [bytes + 2] = 0xff;
            assert [bytes + 3] = 0xee;

            return ();
        }
    }
}
