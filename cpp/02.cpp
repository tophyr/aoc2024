#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <numeric>
#include <vector>

#include "util.h"

int main(int argc, char* argv[]) {
  std::vector<int> left, right;
  std::map<int, size_t> right_freq;
  
  ASSERT_EQ(argc, 2) << "Usage: " << argv[0] << " <data file>";

  {
    std::ifstream data{argv[1]};
    while (data) {
      data >> left;
      data >> right;
    }
  }

  ASSERT_EQ(left.size(), right.size());

  size_t similarity = std::transform_reduce(
      left.begin(),
      left.end(),
      0,
      std::plus<size_t>{},
      [&](int id) {
        if (right_freq.count(id) == 0) {
          right_freq[id] = std::count(right.begin(), right.end(), id);
        }
        return id * right_freq[id];
      });

  std::cout << similarity << std::endl;

  return 0;
}
