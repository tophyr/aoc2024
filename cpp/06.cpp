#include <fstream>
#include <iostream>
#include <numeric>
#include <regex>
#include <string>
#include <vector>

#include "util.h"

std::string read_data(std::string_view datafile) {
  std::ifstream data{datafile};
  std::string str;
  std::getline(data, str, '\0');
  return str;
}

std::vector<std::pair<int, int>> find_muls(std::string mem) {
  std::vector<std::pair<int, int>> muls;
  std::regex pattern{"(mul|do|don't)\\(((\\d+),(\\d+))?\\)"};
  std::transform(
      std::sregex_iterator{mem.begin(), mem.end(), pattern}, 
      std::sregex_iterator{}, 
      std::back_inserter(muls), 
      [enabled = true](auto const& match) mutable {
        if (match[1] == "do") {
          enabled = true;
        } else if (match[1] == "don't") {
          enabled = false;
        } else if (match[1] == "mul" && enabled) {
          return std::pair{atoi(match[3].str().c_str()), atoi(match[4].str().c_str())};
        }
        return std::pair{0, 0};
      });
  return muls;
}

int main(int argc, char* argv[]) {
  ASSERT_EQ(argc, 2) << "Usage: " << argv[0] << " <data file>";
  auto data = find_muls(read_data(argv[1]));

  int total{};
  for (auto const& [a, b] : data) {
    total += a * b;
  }

  std::cout << total << std::endl;

  return 0;
}
