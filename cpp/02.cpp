#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <numeric>
#include <vector>

int main(int argc, char* argv[]) {
  std::vector<int> left, right;
  std::map<int, size_t> right_freq;
  
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
