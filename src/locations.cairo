from starkware.cairo.lang.compiler.lib.registers import get_fp_and_pc
from labels import data_label

func test_use_data() {
    let (_, pc) = get_fp_and_pc();
    pc_label:

    let data = pc + (data_label - pc_label);

    assert [data + 0] = 1;
    assert [data + 1] = 2;
    assert [data + 2] = 3;
    assert [data + 3] = 4;

    return ();

}
