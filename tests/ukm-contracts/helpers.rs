fn require(condition: bool, message: str) {
    if !condition {
        :: helpers :: fail(:: ukm :: EVMC_REVERT);
    }
}

fn fail(code: u64) {
    :: state_hooks :: setStatus(code);
    :: state_hooks :: setOutput(:: bytes_hooks :: empty());
    :: helpers :: cancel_request();
}

extern "C" {
    fn cancel_request() -> !;
}