#include <iostream>
#include <sstream>
#include <vector>

namespace {

template <typename T>
inline std::istream& operator>>(std::istream& in, std::vector<T>& vec) {
  T t;
  in >> t;
  if (in) {
    vec.push_back(std::move(t));
  }
  return in;
}

template <typename T>
struct expect_t {
  explicit expect_t(T expected)
    : expected_{expected} {}

  T const expected_;
};

template <typename T>
std::istream& operator>>(std::istream& in, expect_t<T> expected) {
  T t;
  if (!(in >> t) || t != expected.expected_) {
    in.setstate(std::ios::failbit);
  }
  return in;
}

template <typename T>
inline auto expect(T expected) {
  return expect_t{expected};
}

struct LoggingAborter {  
  template <typename X, typename Y>
  LoggingAborter(std::string_view xname, X const& xval, std::string_view yname, Y const& yval)
    : terminate_{xval != yval} {
    if (xval != yval) {
      std::clog << xname << " (" << xval << ") != " << yname << " (" << yval << ")" << std::endl;
    }
  }

  ~LoggingAborter() {
    if (terminate_) {
      std::clog << stream_.str() << std::endl;
      std::terminate();
    }
  }

  std::ostream& stream() {
    return stream_;
  }

  bool terminate_;
  std::stringstream stream_{};
};

} // namespace

#define ASSERT_EQ(x, y) LoggingAborter{#x, x, #y, y}.stream()
