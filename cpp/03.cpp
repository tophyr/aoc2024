#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <numeric>
#include <sstream>
#include <vector>

#include "util.h"

std::vector<std::vector<int>> read_data(std::string_view datafile) {
  std::vector<std::vector<int>> reports;
  std::ifstream data{datafile};
  std::string line;
  while (std::getline(data, line)) {
    std::stringstream ss{line};
    reports.emplace_back();
    while (ss >> reports.back());
  }
  return reports;
}

int main(int argc, char* argv[]) {
  ASSERT_EQ(argc, 2) << "Usage: " << argv[0] << " <data file>";
  auto reports = read_data(argv[1]);

  int safe{};
  for (auto const& report : reports) {
    bool inc = report[1] > report[0];
    for (int i = 1; i < report.size(); i++) {
      int diff = (report[i] - report[i - 1]) * (inc ? 1 : -1);
      if (diff < 1 || diff > 3) {
        safe--;
        break;
      }
    }
    safe++;
  }

  std::cout << safe << std::endl;

  return 0;
}
