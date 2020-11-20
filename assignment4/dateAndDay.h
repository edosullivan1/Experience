#pragma once
#include "pch.h"
#include "date.h"
#include <iomanip>

enum dayOfWeek { Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday };

class dateAndDay : public date {

private:


public:
	dayOfWeek getDayOfWeek(date *input_date);
	void printDayOfWeek(dayOfWeek d);

};