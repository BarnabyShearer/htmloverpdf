import sys

from . import render


def maini() -> None:
    sys.stdout.buffer.write(render(sys.stdin.read()))


if __name__ == "__main__":
    main()
