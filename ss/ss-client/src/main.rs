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

extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate bincode;
extern crate serde_json;

use crate::data::Sensor;
use slog::Drain;
use std::fs::OpenOptions;
use std::{thread, time};

mod data;
mod error;

/// Set a custom pretty timestamp format for the logging part.
fn custom_timestamp_local(io: &mut ::std::io::Write) -> ::std::io::Result<()> {
    write!(io, "{}", chrono::Utc::now().format("%Y-%m-%d %H:%M:%S"))
}

/// Initialises our log facility by setting it as async and the timestamp format.
fn init_log() -> slog::Logger {
    // Let's write logs to a file for easy retrival.
    let log_path = format!(
        "ss-client_{}.log",
        chrono::Utc::now().format("%Y-%m-%dT%H-%M-%S")
    );
    let file = OpenOptions::new()
        .create(true)
        .write(true)
        .truncate(true)
        .open(log_path)
        .unwrap();
    let decorator = slog_term::PlainDecorator::new(file);

    // Or on the console.
    // let decorator = slog_term::TermDecorator::new().build();

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

    // For pragmatique reasons, we will implement this solution as a simple infinite loop, but a
    // better approach would be to use an event loop to handle different frequency of measument for
    // different sensor
    loop {
        for (iface, mac) in &ifaces_hm {
            debug!("Scan from '{}': {:#?}", iface, mac);

            let mut wifi = data::Wifi::new(iface, mac);
            wifi.fetch().expect("Fail to fetch measurements.");
            wifi.store().expect("Fail to store measurements.");
        }

        // Let's sleep for some time now
        // Every 1h for now.
        let sleep_time_sec = 60 * 60;
        // let sleep_time_sec = 10;
        debug!("Sleeping {}sec", sleep_time_sec);
        thread::sleep(time::Duration::from_secs(sleep_time_sec));
        debug!("---")
    }
}
