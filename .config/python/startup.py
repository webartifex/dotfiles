"""Move Python's history file to "$XDG_STATE_HOME/python/history"."""

import atexit
import os
import readline
import sys


# For Python 3.13+ let `$PYTHON_HISTORY` handle it
if sys.version_info >= (3, 13):
    sys.exit(0)


# For Python 2, do nothing
try:
    import pathlib
except ImportError:
    sys.exit(0)


if readline.get_current_history_length() == 0:
    state_home = os.environ.get("XDG_STATE_HOME")

    if state_home is None:
       state_home = pathlib.Path.home() / ".local" / "state"
    else:
       state_home = pathlib.Path(state_home)

    history_path = state_home / "python" / "history"
    history_path.parent.mkdir(parents=True, exist_ok=True)

    history_location = str(history_path)

    if history_path.is_dir():
        msg = history_location + " must not be a directory"
        raise OSError(msg)

    try:
        readline.read_history_file(history_location)
    except OSError:  # Non existent
        pass

    readline.set_auto_history()
    readline.set_history_length(99999)

    def write_history():
        try:
            readline.write_history_file(history_location)
        except OSError:
            pass

    atexit.register(write_history)

