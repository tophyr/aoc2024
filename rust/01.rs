use std::env;
use std::process;
use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;

fn main() {
    if env::args().count() < 2 {
        eprintln!("Usage: {} <data file>", env::args().nth(0).unwrap());
        process::exit(1);
    }

    let (mut left, mut right): (Vec<i32>, Vec<i32>) = BufReader::new(File::open(env::args().nth(1).unwrap()).unwrap()).lines()
        .map(|e| e.unwrap().split_whitespace()
            .map(|e| e.parse::<i32>().unwrap())
            .collect::<Vec<i32>>())
        .map(|e| (e[0], e[1]))
        .unzip();

    if left.len() != right.len() {
        eprintln!("left size: {}", left.len());
        eprintln!("right size: {}", right.len());
        process::exit(2);
    }

    left.sort();
    right.sort();
    
    let dist = left.into_iter().zip(right.into_iter())
        .map(|(l, r)| (l - r).abs())
        .reduce(|acc, e| acc + e).unwrap();

    println!("{dist}");
}
