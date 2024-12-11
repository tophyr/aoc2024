use std::env;
use std::process;
use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;

fn is_safe(report: &Vec<i32>) -> bool {
    report.is_sorted_by(|a, b| a < b && (a + 3) >= *b) || report.is_sorted_by(|a, b| a > b && (a - 3) <= *b)
}

fn main() {
    if env::args().count() < 2 {
        eprintln!("Usage: {} <data file>", env::args().nth(0).unwrap());
        process::exit(1);
    }

    let reports = BufReader::new(File::open(env::args().nth(1).unwrap()).unwrap()).lines()
        .map(|e| e.unwrap().split_whitespace()
            .map(|e| e.parse().unwrap())
            .collect());

    let safe = reports
        .filter(is_safe)
        .count();

    println!("{safe}");
}
