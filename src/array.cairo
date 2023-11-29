from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_not_zero

struct Address {
    starknet: felt,
    evm: felt,
}


struct Transfer {
    sender: Address*,
    recipient: Address*,
    amount: Uint256,
}

func reverse(arr_len: felt, arr: felt*) -> (rev: felt*) {
    alloc_locals;

    if (arr_len == 0) {
        return (rev=arr);
    }

    let (local rev: felt*) = alloc();
    tempvar i = arr_len;

    body:
    let arr_len = [fp - 4];
    let arr = cast([fp - 3], felt*);
    let rev = cast([fp], felt*);
    let i = [ap - 1];

    assert [rev + i - 1] = [arr + arr_len - i];
    tempvar i = i - 1;

    jmp body if i != 0;

    let rev = cast([fp], felt*);
    return (rev=rev);
}

func copy(transfers_len: felt, transfers: Transfer*) -> (new_transfers: Transfer*) {
    alloc_locals;
    let (local new_transfers: felt*) = alloc();
    memcpy(dst=new_transfers, src=transfers, len=transfers_len * Transfer.SIZE);

    return (cast(new_transfers, Transfer*),);
}

func count_not_zero(arr_len: felt, arr: felt*) -> felt {

        if (arr_len == 0) {
            return 0;
        }

        tempvar len = arr_len;
        tempvar count = 0;
        tempvar arr = arr;

        body:
        let len = [ap - 3];
        let count = [ap - 2];
        let arr = cast([ap - 1], felt*);
        let not_zero = is_not_zero([arr]);

        tempvar len = len - 1;
        tempvar count = count + not_zero;
        tempvar arr = arr + 1;

        jmp body if len != 0;

        let count = [ap - 2];

        return count;
}

func test_count_not_zero_returns_count() {
    alloc_locals;

    let (arr: felt*) = alloc();
    assert [arr] = 0;
    assert [arr + 1] = 1;
    assert [arr + 2] = 2;
    assert [arr + 3] = 0;

    let count = count_not_zero(4, arr);
    assert count = 2;

    return ();
}

func test_count_not_zero_empty_array() {
    alloc_locals;

    let (arr: felt*) = alloc();
    let count = count_not_zero(0, arr);
    assert count = 0;

    return ();
}

func test_vector_capacity_exceeded() {
    let (arr: felt*) = alloc();
    memset(arr, 0, 0xffffffff);
    return ();
}

func test__copy__should_return_copied_segment() {
    alloc_locals;
    tempvar address_0 = new Address(1, 1);
    tempvar address_1 = new Address(2, 2);
    let amount = Uint256(3, 4);
    tempvar transfer_0 = Transfer(address_0, address_1, amount);
    tempvar transfer_1 = Transfer(address_1, address_0, amount);
    let (local transfers: Transfer*) = alloc();
    assert transfers[0] = transfer_0;
    assert transfers[1] = transfer_1;

    let (transfers_copy) = copy(2, transfers);

    let transfer = transfers;
    let transfer_copy = transfers_copy;

    assert transfer_copy.sender.starknet = transfer.sender.starknet;
    assert transfer_copy.sender.evm = transfer.sender.evm;
    assert transfer_copy.recipient.starknet = transfer.recipient.starknet;
    assert transfer_copy.recipient.evm = transfer.recipient.evm;
    assert transfer_copy.amount = transfer.amount;
    assert transfer_copy.amount = transfer.amount;

    return ();
}

func test__reverse__should_reverse_empty() {
    alloc_locals;

    let (arr: felt*) = alloc();

    let (rev) = reverse(0, arr);

    return ();
}

func test__reverse__should_reverse_non_empty() {
    alloc_locals;

    let (arr: felt*) = alloc();
    assert [arr] = 1;
    assert [arr + 1] = 2;
    assert [arr + 2] = 3;

    let (rev) = reverse(3, arr);

    assert [rev] = 3;
    assert [rev + 1] = 2;
    assert [rev + 2] = 1;

    return ();
}
