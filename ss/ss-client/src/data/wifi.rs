//! This is where the magic about the wifi data gathering will take place.

extern crate chrono;

use crate::data::SError;
use crate::data::Sensor;
use crate::error::GenResult;
use chrono::prelude::*;
use std::io::{BufWriter, Write};
use wifiscanner::{self, Wifi as AP}; // AP is short for Access Point

/// The temporary directory where the measurements are stored before being send to the cloud.
const MEASUREMENTS_TMP_DIR: &str = "ss-client_storage/";
/// Extension file format.
const EXT: &str = "json";

/// This is the data structure representing all the intel we can, or need to gather about the wifi.
#[derive(Clone, Debug, Serialize, Deserialize)]
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
            values: Vec::with_capacity(64),
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
            self.index = vec![Utc::now()];
            self.values = wscan.to_owned();

            // debug!("Scan from {}: {:#?}", &self.iface, wscan);
            debug!("Dumping {} values from {}.", wscan.len(), &self.iface);
            Ok(wscan.len() as u32)
        } else {
            return Err(SError::IO);
        }
    }

    /// Stores the mesurements from a Sensor on the disk.
    fn store(&mut self) -> GenResult<String> {
        // The relative root path of the files containing the measurement
        let sensors_dir = self
            .get_root_storage_path()?
            .join(MEASUREMENTS_TMP_DIR)
            .join(&self.mac);

        // Let's compute our storage file name.
        let file_name = sensors_dir.join(format!(
            "{}_{}.{}",
            &self.mac,
            Utc::now().format("%Y-%m-%dT%H:%M:%S"),
            EXT
        ));
        debug!("Storing the measurements in '{:?}'.", &file_name);

        // Let's create the directory of our file if it doesn't exist already
        use std::fs;
        let basename = file_name.parent().unwrap();

        if !basename.exists() {
            // let basename = basename.to_string_lossy().replace(":", "");
            fs::create_dir_all(basename)?;
        }

        // This is where we actually dump the values we previously measure
        match fs::File::create(&file_name) {
            Err(e) => crit!("Fail to create file '{:?}': {:?}.", &file_name, e),
            Ok(file) => {
                let mut buffer = BufWriter::new(file);
                match buffer.write_all(self.to_json().unwrap().as_bytes()) {
                    Ok(_) => (),
                    Err(e) => crit!("Fail to wite in '{:?}': {:?}.", &file_name, e),
                }
            }
        }

        Ok(file_name.to_string_lossy().to_string())
    }

    /// Serialize this data structure a JSON string.
    fn to_json(&self) -> Result<String, SError> {
        // match serde_json::to_string_pretty(&self) {
        match serde_json::to_string(&self) {
            Err(e) => {
                crit!(
                    "Fail to serialize to JSON: '{:#?}' \
                     \n>>{:?}.",
                    &self,
                    e
                );
                Err(SError::Serialize)
            }
            Ok(o) => Ok(o),
        }
    }

    /// Update shadow thing state using the MQTT protocol.
    fn update_shadow_thing(&self, json_path: &str) -> Result<String, SError> {
        use std::process::Command;

        let res = match Command::new("python3")
                .arg("src/aws-iot-update-shadow.py")
                .arg(json_path.clone())
                .arg("")
                // .output().unwrap_or_else(|e| {
                // panic!("failed to execute process: {}", e)
                // });
                .spawn() {
                    Err(e) => {
                        crit!("Fail to submit data using Python SDK: \
                              \n>>{:#?}",
                              e);
                       Err(SError::MQTT)
                    }
                    Ok(o) => Ok(o)
                };

        // Ok(format!("{:#?}", res))
        Ok(format!("{:#?}", res.unwrap()))
    }
}
