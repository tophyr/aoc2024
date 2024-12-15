#include <fstream>
#include <iostream>
#include <numeric>
#include <regex>
#include <string>
#include <vector>

#include "util.h"

std::vector<std::string> read_data(std::string_view datafile) {
  std::vector<std::string> ret;
  std::ifstream data{datafile};
  while (data) {
    data >> ret;
  }
  return ret;
}

bool match_string(std::vector<std::string> const& grid, int x, int x_step, int y, int y_step, std::string_view needle) {
  return needle.empty() || (
    y >= 0 && y < grid.size() && x >= 0 && x < grid[y].size() &&
    needle[0] == grid[y][x] &&
    match_string(grid, x + x_step, x_step, y + y_step, y_step, needle.substr(1)));
}

int main(int argc, char* argv[]) {
  ASSERT_EQ(argc, 2) << "Usage: " << argv[0] << " <data file>";
  auto grid = read_data(argv[1]);

  int count = 0;
  for (int y = 0; y < grid.size(); y++) {
    for (int x = 0; x < grid[y].size(); x++) {
      int inner_count = 0;
      for (int y_off = -1; y_off <= 1; y_off += 2) {
        for (int x_off = -1; x_off <= 1; x_off += 2) {
          if (match_string(grid, x + x_off, -x_off, y + y_off, -y_off, "MAS")) {
            inner_count++;
          }
        }
      }
      if (inner_count == 2) {
        count++;
      }
    }
  }

  std::cout << count << std::endl;

  return 0;
}
