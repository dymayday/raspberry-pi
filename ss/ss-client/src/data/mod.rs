//! This is the entry point from where the data will be gathered, processed if needed.
//! The implementation will be kept as simple as possible, with as little generic as possible for
//! example, because you know, knowledge is power, and I don't want this work to be reused
//! by greedy people ;)

mod wifi;
use std::io::Error as IOError;

pub trait Sensor {
    fn fetch(&mut self) -> Result<u32, IOError>;
    // fn write(&mut self) -> Result<()>;
    // fn store(&mut self) -> Result<u32, std::io::Error>;
    // fn flush(&mut self) -> Result<()>;
    // fn pop(&mut self) -> Result<()>;
}
