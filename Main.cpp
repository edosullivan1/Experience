// number1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
#include "pch.h"
#include <iostream>
#include "factorial.h"
#include <limits
>
using namespace std;

int main() {
	int n;
	cout << "enter number to get the factorial: ";
	cin >> n;

	cout << "the answer is ";
	cout << factorial(n);
	
	cin >> n;

	return 0;
}

