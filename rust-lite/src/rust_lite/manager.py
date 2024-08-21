from __future__ import annotations

import contextlib
import json
import logging
import sys
from collections.abc import Iterable
from typing import TYPE_CHECKING
from pathlib import Path

from pathos.pools import ProcessPool  # type: ignore
from pyk.cli.pyk import parse_toml_args
from pyk.kast.inner import KApply, KSequence, KSort, KToken, Subst
from pyk.cterm import CTerm
from pyk.ktool.krun import KRun
from pyk.prelude.k import GENERATED_TOP_CELL
from pyk.kdist import kdist
from pyk.kore.prelude import top_cell_initializer
from pyk.kore.tools import kore_print
from pyk.utils import FrozenDict

class RustLiteManager():
    krun: KRun
    cterm: CTerm

    def __init__(self) -> None:
        dir_path = Path(f'../.build/rust-kompiled')
        self.krun = KRun(dir_path)
        self._init_cterm()

    def _init_cterm(self) -> None:
        self.krun.definition.empty_config(GENERATED_TOP_CELL)
        
        # init_subst = {
        #     '$PGM': KSequence([KEVM.sharp_execute()]),
        #     '$MODE': KApply('NORMAL'),
        #     '$SCHEDULE': KApply('SHANGHAI_EVM'),
        #     '$USEGAS': TRUE,
        #     '$CHAINID': intToken(0),
        # }

        # init_config = set_cell(init_config, 'ACCOUNTS_CELL', KEVM.accounts(init_accounts_list))

        # init_term = Subst(init_subst)(init_config)
        # self.cterm = CTerm.from_kast(init_term)
