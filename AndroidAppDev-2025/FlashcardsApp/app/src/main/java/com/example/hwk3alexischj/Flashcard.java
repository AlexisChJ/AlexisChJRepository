package com.example.hwk3alexischj;
import java.io.Serializable;
import java.util.ArrayList;

public class Flashcard implements Serializable {

    private String concept;
    private String answer;

    public Flashcard (String concept, String answer) {
        this.concept = concept;
        this.answer = answer;
    }
    public String getAnswer() {
        return answer;
    }
    public String getConcept() {
        return concept;
    }
    public void setAnswer(String answer) {
        this.answer = answer;
    }
    public void setConcept(String concept) {
        this.concept = concept;
    }
}
