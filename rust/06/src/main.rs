use std::env;
use std::process;
use std::fs::read_to_string;
use regex::Regex;

fn main() {
    if env::args().count() < 2 {
        eprintln!("Usage: {} <data file>", env::args().nth(0).unwrap());
        process::exit(1);
    }

    let pattern = Regex::new(r"(do|don't|mul)\(((\d+),(\d+))?\)").unwrap();
    let mem = read_to_string(env::args().nth(1).unwrap()).unwrap();
    let mut enabled = true;
    let res: i32 = pattern.captures_iter(mem.as_str())
        .filter_map(|e| {
            match e.get(1).unwrap().as_str() {
                "do" => { enabled = true; None },
                "don't" => { enabled = false; None },
                "mul" => if enabled { Some((e.get(3).unwrap(), e.get(4).unwrap())) } else { None },
                _ => panic!("bad match")
            }
        })
        .map(|(a, b)| (str::parse::<i32>(a.as_str()).unwrap(), str::parse::<i32>(b.as_str()).unwrap()))
        .map(|(a, b)| a * b)
        .sum();

    println!("{res}");
}
