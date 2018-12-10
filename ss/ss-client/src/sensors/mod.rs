//! This is the entry point where the Sensor data structure is defined.

extern crate chrono;

use chrono::prelude::*;

/// This is our main Sensor data structure from which other sensors will come from.
pub struct Sensor<I,T> {
    /// The unique ID of the sensor
    pub id: u32,
    /// This is a vector of timestamps
    pub index: Index<I>,
    /// The values mesured by the sensor
    pub values: Vec<T>,
    /// This is the frequency of the sensor's mesurements in seconds (as u32 It should be enough for now).
    /// You can see it as the time step of the mesurements.
    pub freq: u32,
}

impl Sensor<DateTime<Utc>, f32> {
    /// This is the main constructor of a Sensor, with no values by default.
    /// Example:
    /// ~~~
    /// // Unique value identifing a sensor.
    /// let sensor_id: u32 = 101;
    /// // This is the frequency at which the sensor will do mesuments,
    /// // you can see it as the time step of the data.
    /// let sensor_freq: u32 = 10*60; // 10 * 60 seconds = 10min frequency
    ///
    /// let sensor = Sensor::new(sensor_id, freq);
    /// ~~~
    pub fn new(id: u32, freq: u32) -> Self {
        Sensor  {
            id,
            index: Index::new(),
            values: Vec::new(),
            freq,
        }
    }
}


/// This data structure is suppose to handle everything related to the date and Timestamps that
/// will most likely server as the only index system.
#[derive(Debug, Clone)]
pub struct Index<I> {
    /// Generic index value, we will only handle *Datetime* for now,
    /// but we give ourself some slack by implementing it with
    /// a generic mind set for a potential future evolution of the API.
    pub value: Vec<I>,
    /// This is an additional lossy compression layer
    pub add_offset: f32,
    /// This is also used as an additional lossly compression layer.
    pub scale_factor: f32,
}

impl Index<DateTime<Utc>> {
    /// Returns the now Timestamp in *Coordinated Universal Time* (UTC).
    pub fn new() -> Self {
        Index {
            value: vec![Utc::now()],
            add_offset: 0.0,
            scale_factor: 1.0,
        }
    }
}


/// The data structure act as a generic data stucture that can handle many differents type (int,
/// float, strings, etc.)
pub struct Dummy {
    
}

impl Dummy {
    pub fn new() -> Self {
        Dummy {  }
    }
}
