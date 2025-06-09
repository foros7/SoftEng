package com.mycompany.softeng.model;

import java.util.ArrayList;
import java.util.List;

public class CalendarWeek {
    private List<CalendarDay> days;

    public CalendarWeek() {
        this.days = new ArrayList<>();
    }

    public List<CalendarDay> getDays() {
        return days;
    }

    public void setDays(List<CalendarDay> days) {
        this.days = days;
    }

    public void addDay(CalendarDay day) {
        this.days.add(day);
    }
}