//! This is where the magic about the wifi data gathering will take place.

extern crate chrono;

use crate::data::Sensor;
use chrono::prelude::*;
// use std::io::Result as IOResult;
use wifiscanner::{self, Wifi as AP}; // AP is short for Access Point
// use crate::error::{GenResult, GenError};
use crate::data::SError;

/// This is the data structure representing all the intel we can, or need to gather about the wifi.
#[derive(Clone,Debug)]
pub struct Wifi {
    /// The mac address of a wireless card. This will act as an universal id,
    /// taken into account that mac address is supposed to be unique in the known universe.
    pub mac: String,
    /// The interface name is used by the sensor, here the wireless card, to gather data around the
    /// system.
    pub iface: String,
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
            iface: iface.to_string(),
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

    /// Runs a mesurement campagn from the 'Sensor' and returns the number of mesurement done during
    /// the campagn.
    fn fetch(&mut self) -> Result<u32, SError> {
        if let Ok(wscan) = wifiscanner::scan(&self.iface) {
            println!("Scan from {}: {:#?}", &self.iface, wscan);
            Ok(wscan.len() as u32)
        } else {
            return Err(SError::IO)
        }
    }


    /// Stores the mesurements from a Sensor on the disk.
    fn store(&mut self) -> Result<(), SError> {
        Ok(())
    }
}
