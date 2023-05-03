import argparse
import os
import subprocess
from datetime import datetime as dt

from dotenv import load_dotenv


def main():
    load_dotenv()
    PROJECT_PATH = os.environ["PROJECT_PATH"]

    timestamp = dt.now().strftime("%Y-%m-%dT%H:%M:%S")

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i", "--input_file", help="実行するNotebookのファイル名", default="train.ipynb"
    )
    parser.add_argument(
        "-o", "--output_file", help="出力されるNotebookのファイル名", default="result.ipynb"
    )
    parser.add_argument("--batch_size", default="8")
    parser.add_argument("--epoch", default="1000")
    args = parser.parse_args()

    # fmt: off
    subprocess.run(
        [
            "poetry",
            "run",
            "papermill",
            f"{PROJECT_PATH}/src/notebooks/{args.input_file}",
            f"{PROJECT_PATH}/data/output/notebooks/{timestamp}_{args.output_file}",
            "-p", "BATCH_SIZE", args.batch_size,
            "-p", "EPOCH", args.epoch,
            "--request-save-on-cell-execute",
            "--prepare-execute",
            "--log-output",
            "--progress-bar"
        ]
    )
    # 結果を改変できないようにロック
    subprocess.run([
        "chmod", "-w",
         f"{PROJECT_PATH}/data/output/notebooks/{timestamp}_{args.output_file}"
    ])
    # fmt: on


if __name__ == "__main__":
    main()
