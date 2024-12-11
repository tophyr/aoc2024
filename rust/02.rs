use std::env;
use std::process;
use std::collections::HashMap;
use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;

fn main() {
    if env::args().count() < 2 {
        eprintln!("Usage: {} <data file>", env::args().nth(0).unwrap());
        process::exit(1);
    }

    let (left, right): (Vec<i32>, Vec<i32>) = BufReader::new(File::open(env::args().nth(1).unwrap()).unwrap()).lines()
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

    let right_freqs = right.into_iter()
        .fold(HashMap::new(), |mut acc, e| { acc.insert(e, acc.get(&e).unwrap_or(&0) + 1); acc });

    let similarity: i32 = left.into_iter()
        .map(|e| e * right_freqs.get(&e).unwrap_or(&0))
        .sum();

    println!("{similarity}");
}
