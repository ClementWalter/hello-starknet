%builtins range_check

from array import Tests as ArrayTests
from dict import Tests as DictTests
from string import Tests as StringTests
from uint256 import Tests as Uint256Tests
from bytes import Tests as BytesTests

func main{range_check_ptr}() {
    // ArrayTests.CountNotZero.test_should_return_count();
    // ArrayTests.CountNotZero.test_should_handle_empty_array();
    // ArrayTests.Reverse.test_should_handle_empty_array();
    // ArrayTests.Reverse.test_should_reverse();

    // BytesTests.BytesToBytes8LittleEndian.test_should_handle_bytes_smaller_than_8();
    BytesTests.BytesToBytes8LittleEndian.test_should_handle_bytes_longer_than_8();

    // Not sure why but need to group tests without range_check_ptr
    // StringTests.FeltToBytes.test_should_return_zero();
    // StringTests.FeltToBytes.test_should_return_one();
    // StringTests.FeltToBytes.test_should_split_little_endian();
    // StringTests.FeltToBytes.test_should_split_with_leading_zeros();

    // ArrayTests.Slice.test_should_handle_out_of_bounds();
    // ArrayTests.Slice.test_should_slice_in_bounds();
    // ArrayTests.Slice.test_should_slice_and_pad();

    // DictTests.DefaultDictCopy.test_should_return_copied_dict();
    // DictTests.DefaultDictCopy.test_should_copy_empty_dict();
    // DictTests.DictKeys.test_should_return_keys();
    // DictTests.DictValues.test_should_return_values();

    // StringTests.FeltToAscii.test_should_return_zero();
    // StringTests.FeltToAscii.test_should_encode_1234();

    // Uint256Tests.Uint256ToBytes.test_should_return_zero();
    // Uint256Tests.Uint256ToBytes.test_should_return_one();
    // Uint256Tests.Uint256ToBytes.test_should_split_little_endian();
    // Uint256Tests.Uint256ToBytes.test_should_handle_uint256_high();
    // Uint256Tests.Uint256ToBytes.test_should_handle_bigger_than_felt();
    return ();
}
