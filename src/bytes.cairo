from starkware.cairo.common.math_cmp import is_le, is_nn
from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.alloc import alloc

func bytes_to_bytes8_little_endian(dst: felt*, bytes_len: felt, bytes: felt*) -> felt {
    alloc_locals;

    if (bytes_len == 0) {
        return (0);
    }

    let (local pow256) = get_label_location(pow256_table);

    tempvar dst_index = 0;
    tempvar bytes_index = bytes_len - 1;
    tempvar bytes8 = 0;
    tempvar bytes8_index = 7;

    body:
    let dst_index = [ap - 4];
    let bytes_index = [ap - 3];
    let bytes8 = [ap - 2];
    let bytes8_index = [ap - 1];

    let bytes_len = [fp - 4];
    let bytes = cast([fp - 3], felt*);
    let pow256 = cast([fp], felt*);
    let current_byte = bytes[bytes_len - 1 - bytes_index];
    let current_pow = pow256[bytes8_index];

    tempvar bytes8 = bytes8 + current_byte * current_pow;

    jmp next if bytes_index != 0;

    assert [dst + dst_index] = bytes8;
    return (dst_index + 1);

    next:
    jmp regular if bytes8_index != 0;

    assert [dst + dst_index] = bytes8;

    tempvar dst_index = dst_index + 1;
    tempvar bytes_index = bytes_index - 1;
    tempvar bytes8 = 0;
    tempvar bytes8_index = 7;
    static_assert dst_index == [ap - 4];
    static_assert bytes_index == [ap - 3];
    static_assert bytes8 == [ap - 2];
    static_assert bytes8_index == [ap - 1];
    jmp body;

    regular:
    tempvar dst_index = dst_index;
    tempvar bytes_index = bytes_index - 1;
    tempvar bytes8 = bytes8;
    tempvar bytes8_index = bytes8_index - 1;
    static_assert dst_index == [ap - 4];
    static_assert bytes_index == [ap - 3];
    static_assert bytes8 == [ap - 2];
    static_assert bytes8_index == [ap - 1];
    jmp body;

    pow256_table:
    dw 256 ** 7;
    dw 256 ** 6;
    dw 256 ** 5;
    dw 256 ** 4;
    dw 256 ** 3;
    dw 256 ** 2;
    dw 256 ** 1;
    dw 256 ** 0;
}

func bytes_to_felt(bytes_len: felt, bytes: felt*) -> felt {
    if (bytes_len == 0) {
        return 0;
    }
    tempvar current = 0;

    // bytes_len, bytes, ?, ?, current
    loop:
    let bytes_len = [ap - 5];
    let bytes = cast([ap - 4], felt*);
    let current = [ap - 1];

    tempvar bytes_len = bytes_len - 1;
    tempvar bytes = bytes + 1;
    tempvar current = current * 256 + [bytes - 1];

    static_assert bytes_len == [ap - 5];
    static_assert bytes == [ap - 4];
    static_assert current == [ap - 1];
    jmp loop if bytes_len != 0;

    ret;
}

namespace Tests {
    namespace BytesToBytes8LittleEndian {
        func test_should_handle_bytes_smaller_than_8() {
            alloc_locals;

            let (bytes: felt*) = alloc();
            assert [bytes + 0] = 0x01;
            assert [bytes + 1] = 0x02;
            assert [bytes + 2] = 0x03;
            assert [bytes + 3] = 0x04;
            assert [bytes + 4] = 0x05;
            assert [bytes + 5] = 0x06;
            let bytes_len = 6;

            let (dst: felt*) = alloc();
            let dst_len = bytes_to_bytes8_little_endian(dst, bytes_len, bytes);

            assert dst_len = 1;
            assert [dst + 0] = 0x060504030201;

            return ();
        }
        func test_should_handle_bytes_longer_than_8() {
            alloc_locals;

            let (bytes: felt*) = alloc();
            assert [bytes + 0] = 0x01;
            assert [bytes + 1] = 0x02;
            assert [bytes + 2] = 0x03;
            assert [bytes + 3] = 0x04;
            assert [bytes + 4] = 0x05;
            assert [bytes + 5] = 0x06;
            assert [bytes + 6] = 0x07;
            assert [bytes + 7] = 0x08;
            assert [bytes + 8] = 0x09;
            let bytes_len = 9;

            let (dst: felt*) = alloc();
            let dst_len = bytes_to_bytes8_little_endian(dst, bytes_len, bytes);

            assert dst_len = 2;
            assert [dst + 0] = 0x0807060504030201;
            assert [dst + 1] = 0x09;

            return ();
        }
    }

    namespace BytesToFelt {
        func test_should_return_zero() {
            let (bytes: felt*) = alloc();
            let res = bytes_to_felt(0, bytes);
            assert res = 0;
            return ();
        }

        func test_should_return_felt_from_bytes4() {
            let (bytes: felt*) = alloc();
            assert [bytes + 0] = 0x01;
            assert [bytes + 1] = 0x02;
            assert [bytes + 2] = 0x03;
            assert [bytes + 3] = 0x04;
            let res = bytes_to_felt(4, bytes);
            assert res = 0x01020304;
            return ();
        }

        func test_should_return_felt_from_bytes8() {
            let (bytes: felt*) = alloc();
            assert [bytes + 0] = 0x01;
            assert [bytes + 1] = 0x02;
            assert [bytes + 2] = 0x03;
            assert [bytes + 3] = 0x04;
            assert [bytes + 4] = 0x05;
            assert [bytes + 5] = 0x06;
            assert [bytes + 6] = 0x07;
            assert [bytes + 7] = 0x08;
            let res = bytes_to_felt(8, bytes);
            assert res = 0x0102030405060708;
            return ();
        }

        func test_should_return_felt_from_bytes16() {
            let (bytes: felt*) = alloc();
            assert [bytes + 0] = 0x01;
            assert [bytes + 1] = 0x02;
            assert [bytes + 2] = 0x03;
            assert [bytes + 3] = 0x04;
            assert [bytes + 4] = 0x05;
            assert [bytes + 5] = 0x06;
            assert [bytes + 6] = 0x07;
            assert [bytes + 7] = 0x08;
            assert [bytes + 8] = 0x09;
            assert [bytes + 9] = 0x0a;
            assert [bytes + 10] = 0x0b;
            assert [bytes + 11] = 0x0c;
            assert [bytes + 12] = 0x0d;
            assert [bytes + 13] = 0x0e;
            assert [bytes + 14] = 0x0f;
            assert [bytes + 15] = 0x10;
            let res = bytes_to_felt(16, bytes);
            assert res = 0x0102030405060708090a0b0c0d0e0f10;
            return ();
        }

        func test_should_return_felt_from_bytes31() {
            let (bytes: felt*) = alloc();
            assert [bytes + 0] = 0x01;
            assert [bytes + 1] = 0x02;
            assert [bytes + 2] = 0x03;
            assert [bytes + 3] = 0x04;
            assert [bytes + 4] = 0x05;
            assert [bytes + 5] = 0x06;
            assert [bytes + 6] = 0x07;
            assert [bytes + 7] = 0x08;
            assert [bytes + 8] = 0x09;
            assert [bytes + 9] = 0x0a;
            assert [bytes + 10] = 0x0b;
            assert [bytes + 11] = 0x0c;
            assert [bytes + 12] = 0x0d;
            assert [bytes + 13] = 0x0e;
            assert [bytes + 14] = 0x0f;
            assert [bytes + 15] = 0x10;
            assert [bytes + 16] = 0x11;
            assert [bytes + 17] = 0x12;
            assert [bytes + 18] = 0x13;
            assert [bytes + 19] = 0x14;
            assert [bytes + 20] = 0x15;
            assert [bytes + 21] = 0x16;
            assert [bytes + 22] = 0x17;
            assert [bytes + 23] = 0x18;
            assert [bytes + 24] = 0x19;
            assert [bytes + 25] = 0x1a;
            assert [bytes + 26] = 0x1b;
            assert [bytes + 27] = 0x1c;
            assert [bytes + 28] = 0x1d;
            assert [bytes + 29] = 0x1e;
            assert [bytes + 30] = 0x1f;
            let res = bytes_to_felt(31, bytes);
            assert res = 0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

            return ();
        }
    }
}
