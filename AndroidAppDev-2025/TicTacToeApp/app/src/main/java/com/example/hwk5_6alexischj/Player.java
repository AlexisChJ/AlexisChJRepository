package com.example.hwk5_6alexischj;

public class Player {
    private int id;
    private String name;
    private int value;
    public Player(){
        this.id = id;
        this.name = name;
    }
    public int getId(){
        return id;
    }
    public int getValue() {
        return value;
    }
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }
    public void setCross(){
        this.value = 1;
    }
    public void setCircle(){
        this.value = 2;
    }
}
