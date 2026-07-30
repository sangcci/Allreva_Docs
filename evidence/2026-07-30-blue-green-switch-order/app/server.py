from argparse import ArgumentParser
from http.server import BaseHTTPRequestHandler, HTTPServer


parser = ArgumentParser()
parser.add_argument("--slot", required=True)
args = parser.parse_args()


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(f"{args.slot}\n".encode())

    def log_message(self, _format, *_args):
        return


HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
