from __future__ import annotations

import contextlib
import json
import logging
import sys
import pprint
from collections.abc import Iterable
from typing import TYPE_CHECKING, Mapping, Any
from pathlib import Path

from pathos.pools import ProcessPool  # type: ignore
from pyk.cli.pyk import parse_toml_args
from pyk.kast.inner import KApply, KSequence, KSort, KToken, KInner
from pyk.kast.parser import KAstParser
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

        ## ATTEMPT 2 ------------------------------------------
        ## Perform the substitution of the $PGM. It seems to be equivalent to the other approaches used.
        # self.krun.definition.empty_config(GENERATED_TOP_CELL)
        # init_config = self.krun.definition.init_config(GENERATED_TOP_CELL)

        # init_subst = {
        #     '$PGM': stringToken(program),
        # }

        # init_term = Subst(init_subst)(init_config)
        # self.cterm = CTerm.from_kast(init_term)

        ## ATTEMPT 3 ------------------------------------------
        ## Manually call kast to get the stdout into a file. Load the file and use KAstParser to convert into a KList
        parser = KAstParser(program)
        parsed_program = parser.klist()
        # _PPRINT.pprint(parsed_program)
        # return

        ## ATTEMPT 4 ------------------------------------------
        ## Using kast to generate a .json of the parsed contract. program should be the content of '../erc20.json'
        # program_json = json.loads(program)
        # parsed_program = KInner.from_dict(program_json['term'])
        # return

        self.cterm = CTerm.from_kast(set_cell(self.cterm.config, 'K_CELL', KSequence(KApply('crateParser(_)_RUST-INDEXING-SYNTAX_Initializer_Crate', parsed_program))))
        pattern = self.krun.kast_to_kore(self.cterm.config, sort=GENERATED_TOP_CELL)
        output_kore = self.krun.run_pattern(pattern, pipe_stderr=False)
        self.cterm = CTerm.from_kast(self.krun.kore_to_kast(output_kore))
        

    def fetch_k_cell_content(self):
        cell = self.cterm.cell('K_CELL')
        _PPRINT.pprint(cell)
        return cell
    





def load_json_dict(input_file: Path) -> Mapping[str, Any]:
    with input_file.open() as f:
        return json.load(f)


def load_json_kinner(input_file: Path) -> KInner:
    value = load_json_dict(input_file)
    return KInner.from_dict(value)