from starkware.cairo.common.registers import get_label_location

func my_loop() {
    [ap] = 2, ap++;

    my_loop:
    [ap] = [ap - 1] * [ap - 1], ap++;
    [ap] = [ap - 1] + 1, ap++;
    jmp my_loop;
}

func jump_rel() {
    [ap + 1] = 3, ap++;
    [ap - 1] = 5201798304953761792, ap++;
    jmp rel -1;
}

func jump_if() {
    [ap] = 10, ap++;

    decrease_loop:
    [ap] = [ap - 1] - 1, ap++;
    jmp decrease_loop if [ap - 1] != 0;
    let a = 1;
    let b = 2;
    let c = a + b;
    %{ print(f"{ids.a + ids.b + ids.c=}") %}
    ret;
}

func opcode_0(z) -> felt{
    %{ print(f"opcode_0") %}
    %{ print(f"{ids.z=}") %}
    return z + 0;
}

func opcode_1(z) -> felt{
    %{ print(f"opcode_1") %}
    %{ print(f"{ids.z=}") %}
    return z + 1;
}

func opcode_2(z) -> felt{
    %{ print(f"opcode_2") %}
    %{ print(f"{ids.z=}") %}
    return z + 2;
}

func opcode_3(z) -> felt{
    %{ print(f"opcode_3") %}
    %{ print(f"{ids.z=}") %}
    return z + 3;
}

func jump_with_jump_param(opcode: felt) -> felt {
    alloc_locals;
    local params_offset;
    local body_offset;

    let params_count = 2;
    assert params_offset = 1 + (params_count * 2 + 2) * opcode;
    assert body_offset = 1 + 3 * opcode;
    jmp params;

    preprocessing:
    let x = [ap - 2];
    %{ print(f"{ids.x=}") %}
    let y = [ap - 1];
    %{ print(f"{ids.y=}") %}
    [ap] = x + y, ap++;

    jmp body;

    params:
    jmp rel [fp];
    // opcode 0
    [ap] = 1, ap++;
    [ap] = 2, ap++;
    jmp preprocessing;
    // opcode 1
    [ap] = 3, ap++;
    [ap] = 4, ap++;
    jmp preprocessing;
    // opcode 2
    [ap] = 5, ap++;
    [ap] = 6, ap++;
    jmp preprocessing;
    // opcode 3
    [ap] = 7, ap++;
    [ap] = 8, ap++;
    jmp preprocessing;

    body:
    jmp rel [fp + 1];
    call opcode_0;
    ret;
    call opcode_1;
    ret;
    call opcode_2;
    ret;
    call opcode_3;
    ret;
}

struct OpcodeParams {
    x: felt,
    y: felt,
}

func jump_with_dw_param(opcode: felt) -> felt {

    let (all_params: OpcodeParams*) = get_label_location(params_data);
    let params = all_params[opcode];

    tempvar offset = 1 + 3 * opcode;
    tempvar z = params.x + params.y;

    jmp rel offset;
    call opcode_0;
    ret;
    call opcode_1;
    ret;
    call opcode_2;
    ret;
    call opcode_3;
    ret;

    params_data:
    // opcode 0
    dw 1;
    dw 2;
    // opcode 1
    dw 3;
    dw 4;
    // opcode 2
    dw 5;
    dw 6;
    // opcode 3
    dw 7;
    dw 8;
}
