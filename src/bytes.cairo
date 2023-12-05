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
}
