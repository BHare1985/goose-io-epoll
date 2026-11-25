// The epoll event loop of goose-io: the contract (`goose_io`) on real sockets, on Linux, one `Loop` per thread.
//
//     import goose_io from "github.com/BHare1985/goose-io@apply-name-resolution";
//     import epoll from "github.com/BHare1985/goose-io-epoll";
//
// It supplies the core and the half_close, sizing, abort, inspection and batching capabilities of contract 0.4, declared in engine.goose (not unix, relay, peek, revoke, wake or limits). A program
// that runs libraries on it calls `goose_io::require_core(io)` and the check of each capability from its root, as docs/event-loops.md says.
// It is built with `goose build` (the C layer is src/sys.c, named in epoll.build); `goose run` cannot link it.
//
// Layout (every file declares `namespace epoll;`; names starting with `_` and `c_` are internal):
//
//     engine.goose    the Loop: links, buffers, sending, dialling, timeouts, serve
//     messages.goose  running several loops, one per thread: spawn, drain, statistics
//     address.goose   "ip:port" as sockets want it, and as the contract writes it
//     config.goose    Limits
//     sys.goose       the C layer's declarations (src/sys.c)
namespace epoll;

import .sys;
import .config;
import .address;
import .engine;
import .messages;
