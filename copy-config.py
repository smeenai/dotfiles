#!/usr/bin/env python3

import argparse
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("config", type=Path)
    args = parser.parse_args()

    config_path = args.config
    with config_path.open() as config:
        config_lines = [l for l in config if not l.endswith("@oss-delete\n")]

    repo_path = Path(__file__).parent / config_path.relative_to(Path.home())
    with repo_path.open("w") as repo_config:
        repo_config.writelines(config_lines)

if __name__ == "__main__":
    main()
