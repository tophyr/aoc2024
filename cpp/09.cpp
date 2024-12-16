#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <tuple>
#include <vector>

#include "util.h"

std::vector<int> to_series(std::string const& str) {
  std::vector<int> pages;
  std::stringstream ss{str};
  while (ss) {
    ss >> pages >> expect(',');
  }
  return pages;
}

struct rule {
  explicit rule(std::string const& str) {
    std::stringstream ss{str};
    ss >> before_ >> expect('|') >> after_;
  }

  bool check(std::vector<int> const& series) const {
    std::optional<size_t> before_idx{}, after_idx{};
    for (int i = 0; i < series.size() && !after_idx; i++) {
      if (series[i] == after_) {
        after_idx = i;
      }
    }
    for (int i = series.size() - 1; i >= 0 && !before_idx; i--) {
      if (series[i] == before_) {
        before_idx = i;
      }
    }
    return !before_idx || !after_idx || *before_idx < *after_idx;
  }

 private:
  int before_;
  int after_;
};

std::tuple<std::vector<rule>, std::vector<std::vector<int>>>
read_data(std::string_view datafile) {
  std::vector<rule> rules;
  std::vector<std::vector<int>> series;
  bool parsing_series{};
  
  std::ifstream in{datafile};
  while (in) {
    std::string str;
    std::getline(in, str);

    if (str.empty()) {
      parsing_series = true;
    } else if (parsing_series) {
      series.push_back(to_series(str));
    } else {
      rules.emplace_back(str);
    }
  }

  return {rules, series};
}

int main(int argc, char* argv[]) {
  ASSERT_EQ(argc, 2) << "Usage: " << argv[0] << " <data file>";
  auto [rules, series] = read_data(argv[1]);

  int sum{};
  for (auto const& s : series) {
    if (std::all_of(rules.begin(), rules.end(), [&](auto const& rule) { return rule.check(s); })) {
      sum += s[s.size() / 2];
    }
  }

  std::cout << sum << std::endl;

  return 0;
}
