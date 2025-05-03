#[starknet::interface]
pub trait ICounter<TContractState>{        // through traits we write type agnostic implementation
    fn get_counter(self: @TContractState) -> u32;  // read only snapshot
    fn increase_counter(ref self: TContractState);
    fn decrease_counter(ref self: TContractState);
    fn reset_counter(ref self: TContractState);

}




#[starknet::contract]
pub mod Counter{

    use starknet::storage::StoragePointerWriteAccess;  //allows us to write to the storage

    #[storage]
    pub struct Storage {
        counter: u32
    }

    #[constructor]
    fn constructor(ref self: ContractState, init_value: u32){
        self.counter.write(init_value);
    }


}