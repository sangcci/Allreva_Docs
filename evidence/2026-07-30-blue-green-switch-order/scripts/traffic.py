from argparse import ArgumentParser
from csv import writer
from pathlib import Path
from signal import SIGINT, SIGTERM, signal
from time import sleep, time
from urllib.error import HTTPError, URLError
from urllib.request import urlopen


parser = ArgumentParser()
parser.add_argument("--url", required=True)
parser.add_argument("--output", required=True)
parser.add_argument("--interval-ms", type=int, default=25)
args = parser.parse_args()

running = True


def stop(_signal, _frame):
    global running
    running = False


signal(SIGINT, stop)
signal(SIGTERM, stop)
Path(args.output).parent.mkdir(parents=True, exist_ok=True)

with open(args.output, "w", newline="") as file:
    csv = writer(file, lineterminator="\n")
    csv.writerow(["timestamp", "status", "body"])
    while running:
        timestamp = f"{time():.6f}"
        try:
            with urlopen(args.url, timeout=1) as response:
                csv.writerow([timestamp, response.status, response.read().decode().strip()])
        except HTTPError as error:
            csv.writerow([timestamp, error.code, "http_error"])
        except (URLError, TimeoutError, OSError):
            csv.writerow([timestamp, 0, "connection_error"])
        file.flush()
        sleep(args.interval_ms / 1000)
