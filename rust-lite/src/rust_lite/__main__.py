from __future__ import annotations

import contextlib
import json
import logging
import sys
from collections.abc import Iterable
from typing import TYPE_CHECKING

from .manager import RustLiteManager

from . import VERSION

if TYPE_CHECKING:
    from argparse import Namespace
    from collections.abc import Callable, Iterator
    from typing import Any, Final, TypeVar

    T = TypeVar('T')

_LOGGER: Final = logging.getLogger(__name__)
_LOG_FORMAT: Final = '%(levelname)s %(asctime)s %(name)s - %(message)s'


def main() -> None:
    print("Instantiating module manager;")

    module_manager = RustLiteManager()

    print("Module manager initiated; Trying to load program into K cell;")

    contract_code = open('../tests/execution/empty.rs', 'r').read()
    # contract_code = open('../tests/syntax/erc_20_token.rs', 'r').read()

    module_manager.load_program(contract_code)

    print("Program loaded; Trying to fetch the content of the K cell.")

    module_manager.fetch_k_cell_content()

