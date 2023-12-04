from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import assert_nn_le, unsigned_div_rem
from starkware.cairo.common.math_cmp import RC_BOUND
from starkware.cairo.common.alloc import alloc

// @dev Use a hint from split_int
func uint256_to_bytes{range_check_ptr}(n: Uint256) -> (bytes_len: felt, bytes: felt*) {
    alloc_locals;
    let (local highest_byte, safe_high) = unsigned_div_rem(n.high, 2 ** 120);
    let (local bytes: felt*) = alloc();
    local range_check_ptr = range_check_ptr;

    let value = n.low + safe_high * 2 ** 128;
    tempvar value = value;
    tempvar bytes_len = 0;

    body:
    let value = [ap - 2];
    let bytes_len = [ap - 1];
    let bytes = cast([fp + 1], felt*);
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

    let highest_byte = [fp];
    let bytes = cast([fp + 1], felt*);

    if (highest_byte != 0) {
        assert [bytes + bytes_len] = highest_byte;
        tempvar bytes_len = bytes_len + 1;
    } else {
        tempvar bytes_len = bytes_len;
    }

    let range_check_ptr = [fp + 2];
    return (bytes_len, bytes);
}

namespace Tests {
    namespace Uint256ToBytes {
        func test_should_return_zero{range_check_ptr}() {
            alloc_locals;
            let n = Uint256(0, 0);
            let (bytes_len, bytes) = uint256_to_bytes(n);
            assert [bytes] = 0;

            return ();
        }

        func test_should_return_one{range_check_ptr}() {
            alloc_locals;
            let n = Uint256(1, 0);
            let (bytes_len, bytes) = uint256_to_bytes(n);
            assert [bytes] = 1;

            return ();
        }

        func test_should_split_little_endian{range_check_ptr}() {
            alloc_locals;
            let n = Uint256(0xeeff, 0);
            let (bytes_len, bytes) = uint256_to_bytes(n);
            assert [bytes] = 0xff;
            assert [bytes + 1] = 0xee;

            return ();
        }

        func test_should_handle_uint256_high{range_check_ptr}() {
            alloc_locals;
            let n = Uint256(0, 0xeeff);
            let (bytes_len, bytes) = uint256_to_bytes(n);
            assert [bytes + 16] = 0xff;
            assert [bytes + 17] = 0xee;

            return ();
        }

        func test_should_handle_bigger_than_felt{range_check_ptr}() {
            alloc_locals;
            let n = Uint256(0, 0xffffffffffffffffffffffffffffffff);
            let (bytes_len, bytes) = uint256_to_bytes(n);
            assert [bytes + 16] = 0xff;
            assert [bytes + 17] = 0xff;
            assert [bytes + 18] = 0xff;
            assert [bytes + 19] = 0xff;
            assert [bytes + 20] = 0xff;
            assert [bytes + 21] = 0xff;
            assert [bytes + 22] = 0xff;
            assert [bytes + 23] = 0xff;
            assert [bytes + 24] = 0xff;
            assert [bytes + 25] = 0xff;
            assert [bytes + 26] = 0xff;
            assert [bytes + 27] = 0xff;
            assert [bytes + 28] = 0xff;
            assert [bytes + 29] = 0xff;
            assert [bytes + 30] = 0xff;
            assert [bytes + 31] = 0xff;

            return ();
        }
    }
}
