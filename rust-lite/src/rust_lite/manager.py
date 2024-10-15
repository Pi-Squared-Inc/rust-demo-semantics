from __future__ import annotations

import pprint
from collections.abc import Iterable
from collections import deque
from typing import TYPE_CHECKING, Mapping, Any
from pathlib import Path

from pyk.kast.formatter import Formatter
from pyk.kast.inner import KApply, KSequence, KSort, KToken, KInner, Subst
from pyk.kast.outer import read_kast_definition
from pyk.kast.parser import KAstParser
from pyk.kast.manip import set_cell
from pyk.cterm import CTerm
from pyk.ktool.krun import KRun
from pyk.ktool.kprint import _kast
from pyk.kore.parser import KoreParser
from pyk.prelude.k import GENERATED_TOP_CELL


_PPRINT = pprint.PrettyPrinter(width=41, compact=True)

class RustLiteManager():
    krun: KRun
    cterm: CTerm

    def __init__(self) -> None:
        dir_path = Path(f'../.build/rust-preprocessing-kompiled')
        self.krun = KRun(dir_path)
        self._init_cterm()

    def _init_cterm(self) -> None:
        self.krun.definition.empty_config(GENERATED_TOP_CELL)
        init_config = self.krun.definition.init_config(GENERATED_TOP_CELL)
        self.cterm = CTerm.from_kast(init_config)

    def load_program(self, program_path: str) -> None:

        returned_process = _kast(file=program_path, definition_dir=f'../.build/rust-preprocessing-kompiled')

        program = returned_process.stdout
        
        parser = KAstParser(program)
        parsed_program = parser.klist()

        return_process = _kast(file='../tests/syntax/args.txt', definition_dir=f'../.build/rust-preprocessing-kompiled')
        args = returned_process.stdout
        parser = KAstParser(args)
        parsed_args = parser.klist()

        print(parsed_args)

        # self.cterm = CTerm.from_kast(set_cell(self.cterm.config, 'K_CELL', KSequence(KApply('crateParser(_,_)_RUST-PREPROCESSING-SYNTAX_Initializer_Crate_TypePath', parsed_program, parsed_args ))))
        # pattern = self.krun.kast_to_kore(self.cterm.config, sort=GENERATED_TOP_CELL)
        # output_kore = self.krun.run_pattern(pattern, pipe_stderr=False)


        # output_kast = self.krun.kore_to_kast(output_kore)
        # defn = read_kast_definition('../.build/rust-preprocessing-kompiled/compiled.json')
        # formatter = Formatter(defn)

        # print("\n\n")
        # print(formatter(output_kast))
        # print("\n\n")
        
        # self.cterm = CTerm.from_kast(self.krun.kore_to_kast(output_kore))
        
    def fetch_k_cell_content(self) -> KToken:
        cell = self.cterm.cell('K_CELL')
        return cell
    
    def print_k_top_element(self) -> None:
        cell = self.fetch_k_cell_content()
        queue: deque[KInner] = deque(cell)

        print('--------------------------------------------------')
        print('K CELL TOP ELEMENT: ')
        if(len(queue) > 0):
            top_cell = queue.popleft()
            _PPRINT.pprint(top_cell)
        else:
            print('Cell is empty.')

    
    def print_constants_cell(self) -> None:
        cell = self.cterm.cell('CONSTANTS_CELL')
        
        print('--------------------------------------------------')
        print('CONSTANTS CELL ELEMENT: ')
        _PPRINT.pprint(cell)
        