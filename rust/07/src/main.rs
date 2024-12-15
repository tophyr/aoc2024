use std::env;
use std::process;
use std::fs::read_to_string;

fn match_string(grid: &Vec<Vec<char>>, x: i32, x_step: i32, y: i32, y_step: i32, needle: &str) -> bool {
    if needle.is_empty() {
        return true;
    }
    if x < 0 || y < 0 {
        return false;
    }
    let x_size : usize = x.try_into().unwrap();
    let y_size : usize = y.try_into().unwrap();
    if y_size >= grid.len() || x_size >= grid.get(y_size).unwrap().len() {
        return false;
    }
    let grid_char = grid.get(y_size).unwrap().get(x_size).unwrap();
    let needle_char = needle.chars().nth(0).unwrap();
    let needle_rem = needle.get(1..).unwrap();
    return *grid_char == needle_char && match_string(grid, x + x_step, x_step, y + y_step, y_step, needle_rem);
}

fn main() {
    if env::args().count() < 2 {
        process::exit(1);
    }

    let grid : Vec<Vec<_>> = read_to_string(env::args().nth(1).unwrap()).unwrap()
        .lines()
        .map(|e| e.chars().collect())
        .collect();

    let mut count = 0;
    for y in 0..grid.len() {
        for x in 0..grid.get(0).unwrap().len() {
            for x_step in -1..2 {
                for y_step in -1..2 {
                    if match_string(&grid, x.try_into().unwrap(), x_step, y.try_into().unwrap(), y_step, "XMAS") {
                        count = count + 1;
                    }
                }
            }
        }
    }

    println!("{count}");
}
