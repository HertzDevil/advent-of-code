# advent-of-code

Solutions for [Advent of Code](https://adventofcode.com/), a series of
programming puzzles released in December every year.

## Features table

|Language|Solution DSL|Downloading|Submission|Login|
|:-:|:-:|:-:|:-:|:-:|
|Crystal|✅|✅|✅|❌|
|Elixir|❌|❌|❌|❌|

* **Solution DSL**: provides a way to write down solutions, verify them against test cases, and derive the answer from the real input, all without explicit boilerplate code
* **Downloading**: automatically downloads puzzle inputs from the website to `/input/[YYYY]/day[DD].txt`, provided `/.session_token` exists
* **Submission**: automatically submits the answer for the last successful solve to the website, provided `/.session_token` exists
* **Login**: Retrieves or refreshes `/.session_token` with OAuth as necessary
