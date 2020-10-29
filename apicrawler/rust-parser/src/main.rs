#[macro_use]
extern crate lazy_static;
extern crate regex;

mod recipe;

use std::collections::HashSet;
use std::env::current_dir;
use std::ffi::OsStr;
use std::fs::{read_dir, File};
use std::io::prelude::*;
use std::io::{self, BufReader};

use regex::Regex;

use recipe::beautify_jsons;

fn main() -> io::Result<()> {
    let ingredients_dir = "../ingredients/";

    // Fetch ingredient units
    let mut ingredients_files: Vec<String> = Vec::new();

    for entry in read_dir(ingredients_dir)? {
        let entry = entry?;
        let path = entry.path();

        if path.is_file() && path.extension().is_some() && path.extension().unwrap() == "txt" {
            ingredients_files.push(String::from(path.as_path().to_str().unwrap()));
        }
    }

    let re = Regex::new(r"^(?:[0-9]+(?:\.[0-9]+)?) (?P<unit>[^ ]+) .+$").unwrap();

    let mut units: HashSet<String> = HashSet::new();

    for ingredients_file in ingredients_files {
        println!("Using ingredients file {}", ingredients_file);

        let f = File::open(ingredients_file)?;
        let f = BufReader::new(f);

        for line in f.lines() {
            let line = &line.unwrap();

            if re.is_match(line) {
                let caps = re.captures(line).unwrap();

                let unit = caps.name("unit").map_or("ERROR", |c| c.as_str());

                units.insert(String::from(unit));
            }
        }
    }

    // Make Regex string from ingredient units
    let re_units = units
        .iter()
        .map(|u| String::from(u))
        .collect::<Vec<String>>()
        .join("|");

    println!("Found units: {}", re_units);

    beautify_jsons("../recipes/", re_units)?;

    Ok(())
}
