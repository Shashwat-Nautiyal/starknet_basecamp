use snforge_std::{declare, DeclareResultTrait, ContractClassTrait};
use starknet::{ContractAddress};
use contracts::counter::{ICounterDispatcher, ICounterDispatcherTrait};
use openzeppelin_access::ownable::interface::{IOwnableDispatcher, IOwnableDispatcherTrait};

const ZERO_COUNT: u32 = 0;

//our owner
fn OWNER()->ContractAddress{
    'OWNER'.try_into().unwrap()
}

fn __deploy__(init_value: u32)-> (ICounterDispatcher, IOwnableDispatcher){
    let contract_class = declare("Counter").unwrap().contract_class();

    //serialize constructor args
    let mut calldata: Array<felt252> = array![];

    init_value.serialize(ref calldata);
    OWNER().serialize(ref calldata);

    //deploy contract
    let (contract_address, _) = contract_class.deploy(@calldata).expect('failed to deploy');

    let counter = ICounterDispatcher{ contract_address: contract_address };
    let ownable = IOwnableDispatcher{ contract_address: contract_address };
    (counter, ownable)

}

#[test]
fn test_counter_deployment(){
    let (counter, ownable) = __deploy__(0);
    //count1
    let count_1 = counter.get_counter();
    assert(count_1 == ZERO_COUNT, 'Counter not set');
    assert(ownable.owner() == OWNER(), 'Owner not set');
}