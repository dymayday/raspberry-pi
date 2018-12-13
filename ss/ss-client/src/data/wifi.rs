//! This is where the magic about the wifi data gathering will take place.

extern crate chrono;

use crate::data::Sensor;
use chrono::prelude::*;
use std::io::Result as IOResult;
use wifiscanner::Wifi as AP; // AP is short for Access Point

/// This is the data structure representing all the intel we can, or need to gather about the wifi.
pub struct Wifi {
    /// The mac address of a wireless card. This will act as an universal id,
    /// taken into account that mac address is supposed to be unique in the known universe.
    pub mac: String,
    /// We choosed to take as an index the timestamp of the mesured data.
    pub index: Vec<DateTime<Utc>>,
    // pub index: Cell<Option<Vec<DateTime<Utc>>>>,
    /// The data we can effectively gather from the wireless network card.
    pub values: Vec<AP>,
    // pub values: Cell<Option<Vec<u8>>>,
}

impl Wifi {
    pub fn new(iface: &str, mac: &str) -> Self {
        Wifi {
            mac: mac.to_string(),
            index: Vec::new(),
            values: Vec::new(),
        }
    }

    // /// Retrieve the mac address of the wireless card.
    // fn mac_address() -> [char; 12] {
    //
    // }
}

impl Sensor for Wifi {
    fn fetch(&mut self) -> IOResult<u32> {
        Ok(0u32)
    }
}
