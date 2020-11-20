#include "pch.h"
#include "date.h"
#include "dateAndDay.h"
#include <iostream>

dayOfWeek dateAndDay::getDayOfWeek(date *input_date)
{
	date *ref_date = new date;
	ref_date->setDate(2018, 10, 28); //using a reference date of 28/10/2018 which is a sunday

	int diff, remainder;
	diff = input_date->difference(ref_date);

	if (diff < 0) {
		diff = -diff;

		remainder = diff % 7;

		switch (remainder) {
		case 0:
			return Sunday;
			break;
		case 6:
			return Monday;
			break;
		case 5:
			return Tuesday;
			break;
		case 4:
			return Wednesday;
			break;
		case 3:
			return Thursday;
			break;
		case 2:
			return Friday;
			break;
		case 1:
			return Saturday;
			break;
		}
	}
	else {
		remainder = diff % 7;

		switch (remainder) {
		case 0:
			return Sunday;
			break;
		case 1:
			return Monday;
			break;
		case 2:
			return Tuesday;
			break;
		case 3:
			return Wednesday;
			break;
		case 4:
			return Thursday;
			break;
		case 5:
			return Friday;
			break;
		case 6:
			return Saturday;
			break;
		}

	}
}

void dateAndDay::printDayOfWeek(dayOfWeek d) {
	switch (d) {
	case Sunday:
		std::cout << "The day is Sunday \n";
		break;
	case Monday:
		std::cout << "The day is Monday \n";
		break;
	case Tuesday:
		std::cout << "The day is Tuesday \n";
		break;
	case Wednesday:
		std::cout << "The day is Wednesday \n";
		break;
	case Thursday:
		std::cout << "The day is Thursday \n";
		break;
	case Friday:
		std::cout << "The day is Friday \n";
		break;
	case Saturday:
		std::cout << "The day is Saturday \n";
		break;
	}
}

