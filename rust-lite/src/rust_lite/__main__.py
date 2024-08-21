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
    print("Instantiating module manager")

    module_manager = RustLiteManager()

    print("Module manager initiated")

    pass

