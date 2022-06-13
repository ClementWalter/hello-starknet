func main_no_args():
    call foo_no_args
    call foo_no_args
    call foo_no_args

    ret
end

func foo_no_args():
    [ap] = 1000; ap++
    ret
end

func foo_args(x, y) -> (z : felt, w : felt):
    [ap] = x + y; ap++  # z.
    [ap] = x * y; ap++  # w.
    ret
end

func main_args():
    let args = cast(ap, foo_args.Args*)
    args.x = 4; ap++
    args.y = 5; ap++
    # Check that ap was advanced the correct number of times
    # (this will ensure arguments were not forgotten).
    static_assert args + foo_args.Args.SIZE == ap
    let foo_ret = call foo_args
    ret
end

func main():
    # call main_no_args
    call main_args
    ret
end
