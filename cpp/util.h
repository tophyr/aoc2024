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
