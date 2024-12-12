use std::env;
use std::process;
use std::fs::read_to_string;
use regex::Regex;

fn main() {
    if env::args().count() < 2 {
        eprintln!("Usage: {} <data file>", env::args().nth(0).unwrap());
        process::exit(1);
    }

    let pattern = Regex::new(r"mul\((\d+),(\d+)\)").unwrap();
    let mem = read_to_string(env::args().nth(1).unwrap()).unwrap();
    let res: i32 = pattern.captures_iter(mem.as_str())
        .map(|e| (e.get(1).unwrap(), e.get(2).unwrap()))
        .map(|(a, b)| (str::parse::<i32>(a.as_str()).unwrap(), str::parse::<i32>(b.as_str()).unwrap()))
        .map(|(a, b)| a * b)
        .sum();

    println!("{res}");
}
