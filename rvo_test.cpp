#include <iostream>
#include <vector>
#include <chrono>

struct BigData {
    std::vector<int> data;
    BigData() : data(10'000'000, 42) {}  // Large data
    BigData(const BigData& other) : data(other.data) {
        std::cout << "Copy constructor\n";
    }
    BigData(BigData&& other) noexcept : data(std::move(other.data)) {
        std::cout << "Move constructor\n";
    }
};

BigData createWithRVO() {
    return BigData();  // RVO typically applied here
}

BigData createWithoutRVO() {
    BigData temp;
    return temp;  // May or may not be elided depending on compiler and flags
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    BigData a = createWithRVO();
    auto mid = std::chrono::high_resolution_clock::now();
    BigData b = createWithoutRVO();
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> rvo_time = mid - start;
    std::chrono::duration<double> non_rvo_time = end - mid;

    std::cout << "With RVO:     " << rvo_time.count() << " seconds\n";
    std::cout << "Without RVO:  " << non_rvo_time.count() << " seconds\n";

    return 0;
}


