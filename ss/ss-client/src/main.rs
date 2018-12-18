extern crate chrono;
#[macro_use(
    slog_o,
    // slog_info,
    slog_debug,
    // slog_warn,
    slog_crit,
    // slog_log,
    // slog_record,
    // slog_record_static,
    // slog_b,
    // slog_kv
)]
extern crate slog;
extern crate slog_async;
#[macro_use]
extern crate slog_scope;
extern crate slog_term;

use slog::Drain;
use crate::data::Sensor;

mod data;
mod error;

/// Set a custom pretty timestamp format for the logging part.
fn custom_timestamp_local(io: &mut ::std::io::Write) -> ::std::io::Result<()> {
    write!(io, "{}", chrono::Local::now().format("%Y-%m-%d %H:%M:%S"))
}

/// Initialises our log facility by setting it as async and the timestamp format.
fn init_log() -> slog::Logger {
    let decorator = slog_term::TermDecorator::new().build();
    let drain = slog_term::CompactFormat::new(decorator)
        .use_custom_timestamp(custom_timestamp_local)
        .build()
        .fuse();
    let drain = slog_async::Async::new(drain).build().fuse();
    slog::Logger::root(drain, slog_o!())
}

fn main() {
    println!();
    // We need to init the logging facility in order to use it globally and asynchronously
    let _guard = slog_scope::set_global_logger(init_log());

    let ifaces_hm =
        data::list_network_interfaces().expect("Fail to list the network cards on the system.");

    for (iface, mac) in &ifaces_hm {
        debug!("Scan from '{}': {:#?}", iface, mac);

        let mut wifi = data::Wifi::new(iface, mac);
        wifi.fetch()
            .expect("Fail to fetch mesurement.");
    }
}
