from __future__ import annotations

import contextlib
import json
import logging
import sys
import pprint
from collections.abc import Iterable
from typing import TYPE_CHECKING
from pathlib import Path

from pathos.pools import ProcessPool  # type: ignore
from pyk.cli.pyk import parse_toml_args
from pyk.kast.inner import KApply, KSequence, KSort, KToken, Subst
from pyk.kast.manip import set_cell
from pyk.cterm import CTerm
from pyk.ktool.krun import KRun
from pyk.prelude.k import GENERATED_TOP_CELL
from pyk.kdist import kdist
from pyk.kore.prelude import top_cell_initializer
from pyk.kore.tools import kore_print
from pyk.utils import FrozenDict
from pyk.prelude.string import stringToken

_PPRINT = pprint.PrettyPrinter(width=41, compact=True)

class RustLiteManager():
    krun: KRun
    cterm: CTerm

    def __init__(self) -> None:
        dir_path = Path(f'../.build/rust-kompiled')
        self.krun = KRun(dir_path)
        self._init_cterm()

    def _init_cterm(self) -> None:
        self.krun.definition.empty_config(GENERATED_TOP_CELL)
        init_config = self.krun.definition.init_config(GENERATED_TOP_CELL)
        self.cterm = CTerm.from_kast(init_config)

    def load_program(self, program: str) -> None:
        # self.cterm = CTerm.from_kast(set_cell(self.cterm.config, 'K_CELL', KApply(program, [])))
        self.cterm = CTerm.from_kast(set_cell(self.cterm.config, 'K_CELL', stringToken(program)))
        pattern = self.krun.kast_to_kore(self.cterm.config, sort=GENERATED_TOP_CELL)
        output_kore = self.krun.run_pattern(pattern, pipe_stderr=True)
        self.cterm = CTerm.from_kast(self.krun.kore_to_kast(output_kore))
        

    def fetch_k_cell_content(self):
        cell = self.cterm.cell('K_CELL')
        # assert type(cell) is KToken
        _PPRINT.pprint(cell)
        return cell