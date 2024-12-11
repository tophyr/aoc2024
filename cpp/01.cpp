#include <algorithm>
#include <fstream>
#include <iostream>
#include <numeric>
#include <vector>

#include "util.h"

int main(int argc, char* argv[]) {
  std::vector<int> left, right;
  
  ASSERT_EQ(argc, 2) << "Usage: " << argv[0] << " <data file>";

  {
    std::ifstream data{argv[1]};
    while (data) {
      data >> left;
      data >> right;
    }
  }

  ASSERT_EQ(left.size(), right.size());

  std::sort(left.begin(), left.end());
  std::sort(right.begin(), right.end());

  size_t dist = std::inner_product(
      left.begin(), 
      left.end(), 
      right.begin(), 
      0, 
      std::plus<int>{}, 
      [](int a, int b) {
        return std::abs(a - b);
      });
  std::cout << dist << std::endl;

  return 0;
}
