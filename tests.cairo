%builtins range_check

from array import Tests as ArrayTests
from dict import Tests as DictTests
from string import Tests as StringTests

func main{range_check_ptr}() {
    ArrayTests.CountNotZero.test_should_return_count();
    ArrayTests.CountNotZero.test_should_handle_empty_array();
    ArrayTests.Reverse.test_should_handle_empty_array();
    ArrayTests.Reverse.test_should_reverse();

    DictTests.DefaultDictCopy.test_should_return_copied_dict();
    DictTests.DefaultDictCopy.test_should_copy_empty_dict();
    DictTests.DictKeys.test_should_return_keys();
    DictTests.DictValues.test_should_return_values();

    StringTests.FeltToAscii.test_should_return_zero();
    StringTests.FeltToAscii.test_should_encode_1234();

    return ();
}
