%builtins range_check

from jump import fibonacci

func main{range_check_ptr}() {

    let res = fibonacci(10);
    %{ print(f"{ids.res=}") %}

    return ();

}
