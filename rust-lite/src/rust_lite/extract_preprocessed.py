from __future__ import annotations

import sys
from pathlib import Path
from typing import TYPE_CHECKING

from pyk.kore.parser import App, KoreParser

if TYPE_CHECKING:
    from pyk.kore.syntax import Pattern


def descend(patt: Pattern, path: list[str]) -> Pattern:
    for s in path:
        if not isinstance(patt, App):
            raise ValueError(type(patt))
        new_patt: Pattern | None = None
        for p in patt.args:
            if isinstance(p, App):
                print(p.symbol, s)
                if p.symbol == s:
                    new_patt = p
                    break
        if new_patt is None:
            raise ValueError(patt.symbol)
        patt = new_patt
    return patt


def main(args: list[str]) -> None:
    if len(args) != 2:
        raise ValueError(args)
    input_kore = Path(args[0]).read_text()
    config = KoreParser(input_kore).pattern()
    config = descend(
        config,
        ["Lbl'-LT-'ulm-full-preprocessed'-GT-'"],
    )
    Path(args[1]).write_text(config.text)


if __name__ == '__main__':
    main(sys.argv[1:])
