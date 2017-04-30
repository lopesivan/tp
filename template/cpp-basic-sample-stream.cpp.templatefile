#include <iostream>
#include <string>
#include <sstream>
#include <algorithm>
#include <iterator>

int main() {
	std::string sentence = "Something in the way she moves...";
	std::istringstream iss(sentence);
    std::ostringstream stream;

	std::copy(std::istream_iterator<std::string>(iss),
             std::istream_iterator<std::string>(),
             std::ostream_iterator<std::string>(stream, "\n"));

	std::string str =  stream.str();
	std::cout << str;
}
