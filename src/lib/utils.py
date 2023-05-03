from argparse import ArgumentParser
from logging import DEBUG, FileHandler, Formatter, StreamHandler, getLogger


def set_logging(log_file_target: str = None):
    """
    loggingの設定済みloggerを返す

    Parameters
    ----------
    log_file_target : str
        設定されている場合、ログの出力をファイルとして書き出す
        e.g. '/path/to/your_file.log'

    Returns
    -------
    logger
        諸々設定済みのlogger
    """
    logger = getLogger(__name__)
    logger.setLevel(DEBUG)
    logger.propagate = False
    # for stdout
    stream_handler = StreamHandler()
    stream_handler.setLevel(DEBUG)
    handler_format = Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    stream_handler.setFormatter(handler_format)
    logger.addHandler(stream_handler)
    # for file output
    if log_file_target is not None:
        file_handler = FileHandler(log_file_target)
        file_handler.setLevel(DEBUG)
        file_handler.setFormatter(handler_format)
        logger.addHandler(file_handler)
    return logger


def parse_arguments():
    parser = ArgumentParser()
    parser.add_argument("--debug-mode", action="store_true", help="debug mode flag")
    parser.add_argument(
        "--message", type=str, default="default-message", help="experiment message"
    )
    parser.add_argument("-gn", "--gpu-num", type=int, default=0, help="select GPU")
    parser.add_argument(
        "--model", type=str, default="sonoisa/t5-base-japanese", help="model name"
    )
    parser.add_argument(
        "--max-token-length", type=int, default=512, help="max token length for model"
    )
    parser.add_argument(
        "--dataset-dir-path", type=str, default="", help="path to dataset directory"
    )
    parser.add_argument("-bs", "--batch-size", type=int, default=1, help="batch size")
    parser.add_argument("-e", "--epochs", type=int, default=1, help="epochs")
    parser.add_argument(
        "-p", "--patience", type=int, default=1, help="for early stopping"
    )
    parser.add_argument(
        "-lr", "--learning-rate", type=float, default=0.01, help="learning rate"
    )
    args = parser.parse_args()
    return args


def set_seed(seed=42):
    import random
    import os
    random.seed(seed)
    os.environ["PYTHONHASHSEED"] = str(seed)
    # np.random.seed(seed)
    # torch.manual_seed(seed)
    # torch.cuda.manual_seed(seed)
    # torch.cuda.manual_seed_all(seed)
    # torch.backends.cudnn.deterministic = True