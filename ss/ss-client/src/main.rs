extern crate chrono;

mod sensors;
// use sensors::Sensor;
use chrono::SubsecRound;

fn main() {
    println!();

    use chrono::{DateTime, Utc};
    let ts = sensors::Index::<DateTime<Utc>>::new();

    println!("dt = {:?}", ts);
    for i in 0..9 {
        println!("dtr({}) = {:?}", i, ts.value[0].round_subsecs(i));
    }
}
