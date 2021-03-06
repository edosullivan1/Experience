#include "pch.h"
#include <iostream>
#include "date.h"
#include "dateAndDay.h"
#include "dateDayAndWeek.h"
#include <iomanip>

int main()
{
	dayOfWeek week_day;
	dateAndDay *pointer1 = new dateAndDay;
	dateAndDay *pointer2 = new dateAndDay;
	dateDayAndWeek *pointer3 = new dateDayAndWeek;
	date *d = new date;
	d->setDate(2018, 10, 14);
	date *e = new date;
	e->setDate(2017, 7, 10);
	int r = d->difference(e);

	std::cout << "The difference is " << r << " days." << std::endl;
	week_day = pointer1->getDayOfWeek(e);
	pointer2->printDayOfWeek(week_day);
	std::cout << "The Week Number is " << pointer3->getWeekNumber(e) << "\n";

	delete d;
	delete e;
}
