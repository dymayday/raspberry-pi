//! This is the entry point from where the data will be gathered, processed if needed.
//! The implementation will be kept as simple as possible, with as little generic as possible for
//! example, because you know, knowledge is power, and I don't want this work to be reused
//! by greedy people ;)

mod wifi;

pub use self::wifi::Wifi;
use std::collections::HashMap;
use std::io::Read;
use crate::error::GenResult;
use std::path::PathBuf;
// use dirs;


/// This is where we gather intel about the network capability of a Linux system.
const NET_CARDS_ROOT_PATH: &str = "/sys/class/net/";

pub trait Sensor {
    /// Do the measurements.
    fn fetch(&mut self) -> Result<u32, SError>;
    /// Stores the measurements on the disk or anywhere we want to.
    fn store(&mut self) -> GenResult<()>;
    /// Retrieve the path of the executable.
    fn get_root_storage_path(&self) -> GenResult<PathBuf> {
        // Ok(env::temp_dir())
        // Ok( dirs::home_dir().unwrap_or_else(env::temp_dir) )
        Ok( PathBuf::from("./") )
    }
    /// To JSON
    fn to_json(&self) -> Result<String, SError>;
    // fn flush(&mut self) -> Result<()>;
    // fn pop(&mut self) -> Result<()>;
}


/// This is our custom Error definition.
#[derive(Debug)]
pub enum SError {
    /// Error from I/O, exp.: bad read, etc.
    IO,
    /// Serializing trouble.
    Serialize,
}


/// List all the available network card on the system along with their mac addresses.
pub fn list_network_interfaces() -> GenResult<HashMap<String, String>> {
    use walkdir::WalkDir;

    let mut card_hm: HashMap<String, String> = HashMap::new();

    // First we need to list all the available network cards on the system
    // Skipping the first entry because it's the root path we are actually listing
    for entry in WalkDir::new(NET_CARDS_ROOT_PATH)
        .into_iter()
        .filter_map(|p| p.ok())
        .skip(1)
    {
        let path = entry.path().display().to_string();

        match path.split('/').collect::<Vec<&str>>().last() {
            Some(interface_name) => {
                let iface_name = interface_name.to_string();

                // Let's focus only on the wireless cards
                // They should start with the letters "wl"
                if iface_name.to_string().starts_with("wl") {
                    // And then, we fetch their mac addresses
                    let mac_address_file = std::path::Path::new(&path.to_owned()).join("address");

                    if let Ok(mut file) = std::fs::File::open(&mac_address_file) {
                        let mut buf = String::new();
                        file.read_to_string(&mut buf)?;
                        let mac_address = buf.trim();
                        debug!("{:?} {}", mac_address_file, mac_address);
                        card_hm.insert(iface_name, mac_address.to_owned());
                    }
                }
            }
            _ => {
                crit!("No network cards detected from '{}'.", NET_CARDS_ROOT_PATH);
            }
        }
    }

    Ok(card_hm)
}
