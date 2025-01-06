use std::env;
use std::fs::read_to_string;
use std::str::FromStr;

#[derive(Debug, PartialEq, Eq)]
struct Reprint {
    pages: Vec<i32>
}
#[derive(Debug, PartialEq, Eq)]
struct ParseReprintError;

impl Reprint {
    fn middle_page(&self) -> Option<&i32> {
        self.pages.get(self.pages.len() / 2)
    }
}

#[derive(Debug, PartialEq, Eq)]
struct Rule {
    before: i32,
    after: i32
}
#[derive(Debug, PartialEq, Eq)]
struct ParseRuleError;

impl Rule {
    fn check(&self, reprint: &Reprint) -> bool {
        reprint.pages.iter()
            .filter(|v| **v == self.before || **v == self.after)
            .is_sorted_by(|l, r| **l == self.before && **r == self.after)
    }
}

impl FromStr for Reprint {
    type Err = ParseReprintError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        Ok(Reprint {
            pages: s.split(',')
                .map(|p| p.parse::<i32>())
                .collect::<Result<Vec<_>, _>>()
                .map_err(|_| Self::Err{})?
        })
    }
}

impl FromStr for Rule {
    type Err = ParseRuleError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        s.split_once('|')
            .and_then(|(b, a)| {
                Some(Rule {
                    before: b.parse::<i32>().ok()?,
                    after: a.parse::<i32>().ok()?
                })
            })
            .ok_or(Self::Err{})
    }
}

fn read_data() -> (Vec<Rule>, Vec<Reprint>) {
    if env::args().count() < 2 {
        panic!("Usage: {} <dat-file>", env::args().nth(0).unwrap());
    }

    let lines = read_to_string(env::args().nth(1).unwrap()).unwrap()
        .lines()
        .map(|e| e.into())
        .collect::<Vec<String>>();
    let mut split = lines.split(|l| l.is_empty());
    let rules = split.next().unwrap_or(&[]).iter()
        .filter_map(|str| FromStr::from_str(str).ok())
        .collect::<Vec<Rule>>();
    let reprints = split.next().unwrap_or(&[]).iter()
        .filter_map(|str| FromStr::from_str(str).ok())
        .collect::<Vec<Reprint>>();

    return (rules, reprints);
}

fn main() {
    let (rules, reprints) = read_data();
    
    let middle_sum : i32 = reprints.iter()
        .filter(|e| rules.iter().all(|r| r.check(e)))
        .filter_map(|e| e.middle_page())
        .sum();

    println!("{middle_sum}");
}
