%builtins range_check

from locations import test_use_data

func main{range_check_ptr}() {

    test_use_data();
    return ();

}
