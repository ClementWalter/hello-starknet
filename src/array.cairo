from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.alloc import alloc

struct Address {
    starknet: felt,
    evm: felt,
}


struct Transfer {
    sender: Address*,
    recipient: Address*,
    amount: Uint256,
}

func copy(transfers_len: felt, transfers: Transfer*) -> (new_transfers: Transfer*) {
    alloc_locals;
    let (local new_transfers: felt*) = alloc();
    memcpy(dst=new_transfers, src=transfers, len=transfers_len * Transfer.SIZE);

    return (cast(new_transfers, Transfer*),);
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
