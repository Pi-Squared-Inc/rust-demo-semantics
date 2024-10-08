from __future__ import annotations

import pprint
from pathlib import Path
from typing import TYPE_CHECKING

from pyk.cterm import CTerm
from pyk.kast.inner import KApply, KSequence
from pyk.kast.manip import set_cell
from pyk.kast.parser import KAstParser
from pyk.ktool.kprint import _kast
from pyk.ktool.krun import KRun
from pyk.prelude.k import GENERATED_TOP_CELL

if TYPE_CHECKING:
    from pyk.kast.inner import KInner

_PPRINT = pprint.PrettyPrinter(width=41, compact=True)


class RustLiteManager:
    krun: KRun
    cterm: CTerm

    def __init__(self) -> None:
        dir_path = Path('../.build/mx-rust-testing-kompiled')
        self.krun = KRun(dir_path)
        self._init_cterm()

    def _init_cterm(self) -> None:
        self.krun.definition.empty_config(GENERATED_TOP_CELL)
        init_config = self.krun.definition.init_config(GENERATED_TOP_CELL)
        self.cterm = CTerm.from_kast(init_config)

    def load_program(self, program_path: str) -> None:

        returned_process = _kast(file=program_path, definition_dir='../.build/rust-preprocessing-kompiled')

        program = returned_process.stdout

        parser = KAstParser(program)
        parsed_program = parser.klist()

        self.cterm = CTerm.from_kast(
            set_cell(
                self.cterm.config,
                'K_CELL',
                KSequence(KApply('crateParser(_)_RUST-PREPROCESSING-SYNTAX_Initializer_Crate', parsed_program)),
            )
        )
        pattern = self.krun.kast_to_kore(self.cterm.config, sort=GENERATED_TOP_CELL)
        output_kore = self.krun.run_pattern(pattern, pipe_stderr=False)
        self.cterm = CTerm.from_kast(self.krun.kore_to_kast(output_kore))

    def fetch_k_cell_content(self) -> KInner:
        cell = self.cterm.cell('K_CELL')
        return cell

    def print_k_top_element(self) -> None:
        cell = self.fetch_k_cell_content()
        k_cell_contents = cell.items if isinstance(cell, KSequence) else [cell]
        print('--------------------------------------------------')
        print('K CELL TOP ELEMENT: ')
        for cell_content in k_cell_contents:
            _PPRINT.pprint(cell_content)

    def print_constants_cell(self) -> None:
        cell = self.cterm.cell('CONSTANTS_CELL')
        print('--------------------------------------------------')
        print('CONSTANTS CELL ELEMENT: ')
        _PPRINT.pprint(cell)
