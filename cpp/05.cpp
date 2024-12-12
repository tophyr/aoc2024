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
  std::regex pattern{"mul\\(((\\d+),(\\d+))\\)"};
  std::transform(
      std::sregex_iterator{mem.begin(), mem.end(), pattern}, 
      std::sregex_iterator{}, 
      std::back_inserter(muls), 
      [](auto const& match) {
        return std::pair{atoi(match[2].str().c_str()), atoi(match[3].str().c_str())};
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
