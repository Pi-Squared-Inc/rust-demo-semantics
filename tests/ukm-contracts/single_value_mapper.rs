#![no_std]

struct SingleValueMapper { key: u64, value_type: () }

fn new(key:u64) -> :: single_value_mapper :: SingleValueMapper {
    :: single_value_mapper :: SingleValueMapper { key: key, value_type: () }
}
