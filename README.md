# goose-io-epoll

The epoll event loop for [goose-io](https://github.com/BHare1985/goose-io), on real sockets, Linux only. One `epoll::Loop` is one thread's event loop. It supplies the
goose-io contract's core and the half-close, sizing, abort, inspection, batching and shared-listen capabilities (not unix, relay, peek, revoke, wake or limits), and passes the conformance suite
on them. It is the generic layer of tcprouter's engine with the proxy removed and the contract's names in place.

This is an example event loop: read it to see what a conforming loop is. [goose-io-epoll-ext](https://github.com/BHare1985/goose-io-epoll-ext) is this loop with
the extra functionality a performant TCP proxy needs.

Self-contained: it fetches goose-io (contract 0.5, branch apply-name-resolution until it is tagged) (`import goose_io from "github.com/BHare1985/goose-io@apply-name-resolution"`) with `goose fetch`. Needs Goose v2026.4,
a C compiler, Python 3 for the network tests.

```bash
./build.sh http_hello.goose http_hello          # goose run cannot link the C layer: programs are built
./conformance.sh --repeat 3                     # the suite, every part of the core and each capability
net/run.sh                                      # the network tests on real peers (REPEAT=20 net/run.sh limits)
```

| File | |
|---|---|
| `engine.goose` | the `Loop`: links, buffers, send queue, dial, timeouts, serve |
| `messages.goose` | several loops, one per thread: `spawn`, `drain`, statistics |
| `address.goose`, `config.goose`, `sys.goose`, `src/sys.c` | addresses, limits, the C layer |
| `conformance.goose` | the runner of the suite, with its fixture |
| `tests/` | programs the network tests drive (and `capabilities_test.goose`, which checks the declared capabilities); `net/` the drivers |

Performance gates against tcprouter's own engine live with goose-io (`bench/`). Differences from tcprouter's engine: a slot is freed after its
`Closed` is handled, `Writable` comes once the largest refused send fits, `close` never resets a link with unread input, and a Tick comes at
least every 90 ms.
