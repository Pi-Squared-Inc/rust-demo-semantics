from __future__ import annotations

import logging
import sys
from collections.abc import Iterable
from pathlib import Path
from typing import TYPE_CHECKING, Any

from pyk.cli.pyk import parse_toml_args

from .cli import _create_argument_parser, generate_options, get_argument_type_setter, get_option_string_destination
from .manager import RustLiteManager

if TYPE_CHECKING:
    from argparse import Namespace
    from typing import Final, TypeVar

    from .cli import RunOptions

    T = TypeVar('T')

_LOGGER: Final = logging.getLogger(__name__)
_LOG_FORMAT: Final = '%(levelname)s %(asctime)s %(name)s - %(message)s'


def main() -> None:
    sys.setrecursionlimit(15000000)
    parser = _create_argument_parser()
    args = parser.parse_args()
    toml_args = parse_toml_args(args, get_option_string_destination, get_argument_type_setter)
    logging.basicConfig(level=_loglevel(args), format=_LOG_FORMAT)

    stripped_args = toml_args | {
        key: val for (key, val) in vars(args).items() if val is not None and not (isinstance(val, Iterable) and not val)
    }

    options = generate_options(stripped_args)

    executor_name = 'exec_' + args.command.lower().replace('-', '_')
    if executor_name not in globals():
        raise AssertionError(f'Unimplemented command: {args.command}')

    execute = globals()[executor_name]
    execute(options)


def exec_run(options: RunOptions) -> None:
    contract_path = str(options.input_file.resolve())

    print('Instantiating module manager;')

    module_manager = RustLiteManager()

    print('Module manager initiated; Trying to load program into K cell;')

    module_manager.load_program(contract_path)

    print('Performed all possible rewriting operations; Trying to fetch the content of the K cell.')

    module_manager.print_k_top_element()


def trigger_exec_run(stripped_args: dict[str, Any]) -> None:
    options = generate_options(stripped_args)
    executor_name = 'exec_run'
    execute = globals()[executor_name]
    execute(options)

def exec_endpoints() -> None:
    stripped_args = {'command': 'run', 'input_file': Path('../.build/ulm-with-contract/output/endpoints.1.run.executed.kore.in.tmp')}
    trigger_exec_run(stripped_args)

def exec_empty() -> None:
    stripped_args = {'command': 'run', 'input_file': Path('../tests/preprocessing/empty.rs')}
    trigger_exec_run(stripped_args)


def exec_erc20() -> None:
    stripped_args = {'command': 'run', 'input_file': Path('../tests/syntax/erc_20_token.rs')}
    trigger_exec_run(stripped_args)


def exec_staking() -> None:
    stripped_args = {'command': 'run', 'input_file': Path('../tests/syntax/staking.rs')}
    trigger_exec_run(stripped_args)


def exec_lending() -> None:
    stripped_args = {'command': 'run', 'input_file': Path('../tests/syntax/lending.rs')}
    trigger_exec_run(stripped_args)


def _loglevel(args: Namespace) -> int:
    if args.debug:
        return logging.DEBUG

    if args.verbose:
        return logging.INFO

    return logging.WARNING
