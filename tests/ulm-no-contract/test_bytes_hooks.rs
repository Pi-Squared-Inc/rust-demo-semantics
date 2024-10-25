#![no_std]

fn empty() -> u64 {
    ::bytes_hooks::empty()
}

fn append_u64(v:u64) -> u64 {
    let id = ::bytes_hooks::empty();
    ::bytes_hooks::append_u64(id, v)
}

fn append_decode_u64(v:u64) -> (u64, u32) {
    let id = ::bytes_hooks::empty();
    let id = ::bytes_hooks::append_u64(id, v);
    ::bytes_hooks::decode_u32(id)
}

fn append_u32(v:u32) -> u64 {
    let id = ::bytes_hooks::empty();
    ::bytes_hooks::append_u32(id, v)
}

fn append_decode_u32(v:u32) -> (u64, u32) {
    let id = ::bytes_hooks::empty();
    let id = ::bytes_hooks::append_u32(id, v);
    ::bytes_hooks::decode_u32(id)
}

fn append_str(v:&str) -> u64 {
    let id = ::bytes_hooks::empty();
    ::bytes_hooks::append_str(id, v)
}

fn append_decode_str(v:&str) -> (u64, str) {
    let id = ::bytes_hooks::empty();
    let id = ::bytes_hooks::append_str(id, v);
    ::bytes_hooks::decode_str(id)
}

fn append_decode_multi_1(v1:u32, v2:str) -> (u64, u32, str) {
    let id = ::bytes_hooks::empty();
    let id = ::bytes_hooks::append_u32(id, v);
    let (id, v32) = ::bytes_hooks::decode_u32(id);
    let (id, vstr) = ::bytes_hooks::decode_str(id);
    (id, v32, vstr)
}
