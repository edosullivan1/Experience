#include <iostream>
#include "pch.h"
#include "factorial.h"
#include <limits>

using namespace std;

int factorial(int n) {

	int x, ans = 1;

	if (n <= INT_MAX) {
		if (n < 0) {

			return 0;
		}
		else {
			for (x = 1; x <= n; x++) {
				if (ans >= INT_MAX / x) {
					return 0;
				}
				ans = ans * x;
			}
			return ans;
		}
	}

	else
		return 0;
}