import os
import sys

# Ensure the dashboard package is importable
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
DASHBOARD_DIR = os.path.join(CURRENT_DIR, "dashboard")

if DASHBOARD_DIR not in sys.path:
    sys.path.insert(0, DASHBOARD_DIR)

import server  # type: ignore  # noqa: E402


def configure_from_env() -> None:
    api_base = os.getenv("API_BASE_URL")
    if api_base:
        server.API_BASE_URL = api_base.rstrip("/")  # type: ignore[attr-defined]

    port = os.getenv("DASHBOARD_PORT")
    if port:
        try:
            server.PORT = int(port)  # type: ignore[attr-defined]
        except ValueError:
            pass


def main() -> None:
    configure_from_env()
    os.chdir(server.DIRECTORY)  # type: ignore[attr-defined]
    server.start_server()


if __name__ == "__main__":
    main()

