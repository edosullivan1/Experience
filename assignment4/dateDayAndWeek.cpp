#include "pch.h"
#include "date.h"
#include "dateAndDay.h"
#include "dateDayAndWeek.h"
#include <iostream>



int dateDayAndWeek::getWeekNumber(date *input_date) {

	//Calculating week numbers according to the ISO week date standard (ISO-8601) which can be seen on this website https://www.epochconverter.com/weeks/2018
	//Week number according to the ISO-8601 standard, weeks starting on Monday. 
	//The first week of the year is the week that contains that year's first Thursday (='First 4-day week').

	int weekNumber = 0, previous_year, diff, number_of_weeks;
	previous_year = input_date->year - 1;
	date *ref_date = new date;
	ref_date->setDate(input_date->year, 1, 1);

	//checking for dates less than 07/01/that year because they could be in week 52 or 53
	if ((input_date->month == 1) && (input_date->day < 8)) {
		for (int i = 1; i < 8; i++) {
			ref_date->setDate(input_date->year, 1, i);
			dayOfWeek checking_for_thurs;
			checking_for_thurs = getDayOfWeek(ref_date);
			if (checking_for_thurs == Thursday) {

				switch (i) {
				case 1:
					if ((input_date->day == 5) || (input_date->day == 6) || (input_date->day == 7)) {
						weekNumber = 2;
					}
					else {
						weekNumber = 1;
					}
					break;
				case 2:
					if ((input_date->day == 6) || (input_date->day == 7)) {
						weekNumber = 2;
					}
					else {
						weekNumber = 1;
					}
					break;
				case 3:
					if (input_date->day == 7) {
						weekNumber = 2;
					}
					else {
						weekNumber = 1;
					}
					break;
				case 4:
					weekNumber = 1;
					break;
				case 5:
					if (input_date->day == 1) {
						if (((previous_year % 4 == 0) && (previous_year % 100 != 0)) || (previous_year % 400 == 0)) {
							weekNumber = 53;
						}
						else {
							weekNumber = 52;
						}

					}
					else {
						weekNumber = 1;
					}
					break;
				case 6:
					if ((input_date->day == 1) || (input_date->day == 2)) {
						if (((previous_year % 4 == 0) && (previous_year % 100 != 0)) || (previous_year % 400 == 0)) {
							weekNumber = 53;
						}
						else {
							weekNumber = 52;
						}
					}
					else {
						weekNumber = 1;
					}
					break;
				case 7:
					if ((input_date->day == 1) || (input_date->day == 2) || (input_date->day == 3)) {
						std::cout << previous_year << "\n";
						if (((previous_year % 4 == 0) && (previous_year % 100 != 0)) || (previous_year % 400 == 0)) {
							weekNumber = 53;
						}
						else {
							weekNumber = 52;
						}
					}
					else {
						weekNumber = 1;
					}
					break;
				}
			}
		}
	}
	else {
		//Checking if dates from 29-31st of Dec are in week 1
		if ((input_date->month == 12) && (input_date->day > 28)) {

			for (int i = 1; i < 4; i++) {
				ref_date->setDate(input_date->year + 1, 1, i);
				dayOfWeek checking_for_thurs;
				checking_for_thurs = getDayOfWeek(ref_date);
				if (checking_for_thurs == Thursday) {
					switch (i) {
					case 1:
						weekNumber = 1;
						break;
					case 2:
						if ((input_date->day == 30) || (input_date->day == 31)) {
							weekNumber = 1;
						}
						else {
							//normal process
						}
						break;
					case 3:
						if (input_date->day == 31) {
							weekNumber = 1;
						}
						else {
							//normal process
						}
						break;

					}
				}
			}


		}
		for (int i = 1; i < 8; i++) {
			ref_date->setDate(input_date->year, 1, i);
			if (getDayOfWeek(ref_date) == Thursday) {
				diff = input_date->difference(ref_date);
				diff = diff + 3;
				number_of_weeks = diff / 7;
				weekNumber = number_of_weeks + 1;
			}
		}

	}
	return weekNumber;
}
