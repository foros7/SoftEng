package com.mycompany.softeng.model;

import java.util.ArrayList;
import java.util.List;

public class CalendarDay {
    private int dayNumber;
    private boolean isCurrentMonth;
    private boolean isToday;
    private List<Appointment> appointments;

    public CalendarDay() {
        this.appointments = new ArrayList<>();
    }

    public CalendarDay(int dayNumber, boolean isCurrentMonth, boolean isToday) {
        this.dayNumber = dayNumber;
        this.isCurrentMonth = isCurrentMonth;
        this.isToday = isToday;
        this.appointments = new ArrayList<>();
    }

    // Getters and Setters
    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public boolean isCurrentMonth() {
        return isCurrentMonth;
    }

    public void setCurrentMonth(boolean currentMonth) {
        isCurrentMonth = currentMonth;
    }

    public boolean isToday() {
        return isToday;
    }

    public void setToday(boolean today) {
        isToday = today;
    }

    public List<Appointment> getAppointments() {
        return appointments;
    }

    public void setAppointments(List<Appointment> appointments) {
        this.appointments = appointments;
    }

    public void addAppointment(Appointment appointment) {
        this.appointments.add(appointment);
    }
}