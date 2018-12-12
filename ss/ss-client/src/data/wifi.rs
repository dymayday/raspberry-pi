//! This is where the magic about the wifi data gathering will take place.

extern crate chrono;

use std::io::Error as IOError;
use crate::data::Sensor;
// use std::cell::Cell;
use chrono::prelude::*;


/// This is the data structure representing all the intel we can, or need to gather about the wifi.
pub struct Wifi {
    /// The mac address of a wireless card. This will act as an universal id,
    /// taken into account that mac address is supposed to be unique in the known universe.
    pub mac: [char; 12],
    /// We choosed to take as an index the timestamp of the mesured data.
    pub index: Vec<DateTime<Utc>>,
    // pub index: Cell<Option<Vec<DateTime<Utc>>>>,
    /// The data we can effectively gather from the wireless network card.
    pub values: Vec<u8>,
    // pub values: Cell<Option<Vec<u8>>>,
}

impl Wifi {
    pub fn new(mac: [char; 12]) -> Self {
        Wifi {
            mac: mac.to_owned(),
            index: Vec::new(),
            values: Vec::new(),
        }
    }
}

impl Sensor for Wifi {
    fn fetch(&mut self) -> Result<u32, IOError> {
        Ok(0u32)
    }
}





