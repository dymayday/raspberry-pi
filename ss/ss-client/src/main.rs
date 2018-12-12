extern crate chrono;

mod data;

fn main() {
    println!();

    // use chrono::{SubsecRound, Utc};
    // let ts = Utc::now();
    //
    // println!("dt = {:?}", ts);
    // for i in 0..9 {
    //     println!("dtr({}) = {:?}", i, ts.round_subsecs(i));
    // }

    use wifiscanner;
    let wscan = wifiscanner::scan();
    println!("Wifi scanner: {:#?}", wscan);
}
