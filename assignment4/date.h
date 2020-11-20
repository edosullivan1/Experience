#pragma once
#include "pch.h"
class date {
private:
	//int year, month, day;
	//int dayNumber;

public:
	int year, month, day;
	int dayNumber;
	date();
	~date();
	void setDate(int y, int m, int d);
	int difference(date *p);
};
