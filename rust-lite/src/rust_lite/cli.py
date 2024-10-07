from __future__ import annotations

import logging
from argparse import ArgumentParser
from functools import cached_property
from typing import TYPE_CHECKING, Any

from pyk.cli.args import DisplayOptions as PykDisplayOptions
from pyk.cli.args import KCLIArgs, KDefinitionOptions, LoggingOptions, Options
from pyk.cli.utils import file_path

if TYPE_CHECKING:
    from collections.abc import Callable
    from pathlib import Path
    from typing import Final, TypeVar

    T = TypeVar('T')

_LOGGER: Final = logging.getLogger(__name__)


def generate_options(args: dict[str, Any]) -> LoggingOptions:
    command = args['command']
    match command:
        case 'version':
            return VersionOptions(args)
        case 'run':
            return RunOptions(args)
        case _:
            raise ValueError(f'Unrecognized command: {command}')


def get_option_string_destination(command: str, option_string: str) -> str:
    option_string_destinations = {}
    match command:
        case 'version':
            option_string_destinations = VersionOptions.from_option_string()
        case 'parse':
            option_string_destinations = RunOptions.from_option_string()

    return option_string_destinations.get(option_string, option_string.replace('-', '_'))


def get_argument_type_setter(command: str, option_string: str) -> Callable[[str], Any]:
    def func(par: str) -> str:
        return par

    option_types = {}
    match command:
        case 'version':
            option_types = VersionOptions.get_argument_type()
        case 'parse':
            option_types = RunOptions.get_argument_type()

    return option_types.get(option_string, func)


def _create_argument_parser() -> ArgumentParser:
    rust_lite_cli_args = RustLiteCLIArgs()
    parser = ArgumentParser(prog='rust-lite')

    command_parser = parser.add_subparsers(dest='command', required=True)

    run_args = command_parser.add_parser(
        'run',
        help='Run Rust-Lite program.',
        parents=[
            rust_lite_cli_args.logging_args,
        ],
    )
    run_args.add_argument('input_file', type=file_path, help='Path to input file.')

    return parser


class KOptions(KDefinitionOptions):
    definition_dir: Path | None
    depth: int | None

    @staticmethod
    def default() -> dict[str, Any]:
        return {
            'definition_dir': None,
            'depth': None,
        }

    @staticmethod
    def from_option_string() -> dict[str, str]:
        return KDefinitionOptions.from_option_string() | {
            'definition': 'definition_dir',
        }

    @staticmethod
    def get_argument_type() -> dict[str, Callable]:
        return KDefinitionOptions.get_argument_type()


class TargetOptions(Options):
    target: str | None

    @staticmethod
    def default() -> dict[str, Any]:
        return {
            'target': None,
        }


class DisplayOptions(PykDisplayOptions):
    sort_collections: bool

    @staticmethod
    def default() -> dict[str, Any]:
        return {
            'sort_collections': False,
        }

    @staticmethod
    def from_option_string() -> dict[str, str]:
        return PykDisplayOptions.from_option_string()

    @staticmethod
    def get_argument_type() -> dict[str, Callable]:
        return PykDisplayOptions.get_argument_type()


class VersionOptions(LoggingOptions):
    @staticmethod
    def from_option_string() -> dict[str, str]:
        return LoggingOptions.from_option_string()

    @staticmethod
    def get_argument_type() -> dict[str, Callable]:
        return LoggingOptions.get_argument_type()


class RunOptions(LoggingOptions):
    input_file: Path

    @staticmethod
    def default() -> dict[str, Any]:
        return {
            'input_file': None,
        }

    @staticmethod
    def from_option_string() -> dict[str, str]:
        return LoggingOptions.from_option_string()

    @staticmethod
    def get_argument_type() -> dict[str, Callable]:
        return {
            'input_file': file_path,
        }


class RustLiteCLIArgs(KCLIArgs):
    @cached_property
    def target_args(self) -> ArgumentParser:
        args = ArgumentParser(add_help=False)
        args.add_argument('--target', choices=['llvm', 'haskell', 'haskell-standalone', 'foundry'])
        return args

    @cached_property
    def k_args(self) -> ArgumentParser:
        args = super().definition_args
        args.add_argument('--depth', type=int, help='Maximum depth to execute to.')
        return args

    @cached_property
    def display_args(self) -> ArgumentParser:
        args = super().display_args
        args.add_argument(
            '--sort-collections',
            dest='sort_collections',
            default=None,
            action='store_true',
            help='Sort collections before outputting term.',
        )
        return args
