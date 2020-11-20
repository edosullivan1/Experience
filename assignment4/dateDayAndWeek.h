#pragma once
#include "pch.h"
#include "date.h"
#include "dateAndDay.h"

class dateDayAndWeek : public dateAndDay {

public:
	int getWeekNumber(date *input_date);
};