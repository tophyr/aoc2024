#include <algorithm>
#include <fstream>
#include <iostream>
#include <numeric>
#include <vector>

int main(int argc, char* argv[]) {
  std::vector<int> left, right;
  
  if (argc < 2) {
    std::cerr << "Usage: " << argv[0] << " <data file>" << std::endl;
    return 1;
  }

  {
    std::ifstream data{argv[1]};
    data.exceptions(std::ios::failbit);
    try {
      while (true) {
        int i;
        data >> i;
        left.push_back(i);
        data >> i;
        right.push_back(i);
      }
    } catch (std::exception const&) {}
  }

  if (left.size() != right.size()) {
    std::cerr << "left size: " << left.size() << std::endl;
    std::cerr << "right size: " << right.size() << std::endl;
    return 2;
  }

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
