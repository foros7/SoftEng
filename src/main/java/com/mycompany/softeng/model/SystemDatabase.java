package com.mycompany.softeng.model;

import java.util.List;
import java.util.ArrayList;

public class SystemDatabase {
    private List<String> listProf;
    private List<String> listStud;
    private List<String> listAppoint;
    private List<String> listAssign;
    private List<String> listMarks;

    public SystemDatabase() {
        this.listProf = new ArrayList<>();
        this.listStud = new ArrayList<>();
        this.listAppoint = new ArrayList<>();
        this.listAssign = new ArrayList<>();
        this.listMarks = new ArrayList<>();
    }

    // Getters and Setters
    public List<String> getListProf() {
        return listProf;
    }

    public void setListProf(List<String> listProf) {
        this.listProf = listProf;
    }

    public List<String> getListStud() {
        return listStud;
    }

    public void setListStud(List<String> listStud) {
        this.listStud = listStud;
    }

    public List<String> getListAppoint() {
        return listAppoint;
    }

    public void setListAppoint(List<String> listAppoint) {
        this.listAppoint = listAppoint;
    }

    public List<String> getListAssign() {
        return listAssign;
    }

    public void setListAssign(List<String> listAssign) {
        this.listAssign = listAssign;
    }

    public List<String> getListMarks() {
        return listMarks;
    }

    public void setListMarks(List<String> listMarks) {
        this.listMarks = listMarks;
    }
}