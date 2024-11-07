#![no_std]

struct SingleValueMapper { key: u256, value_type: () }

fn new(key:u256) -> :: single_value_mapper :: SingleValueMapper {
    :: single_value_mapper :: SingleValueMapper { key: key, value_type: () }
}
