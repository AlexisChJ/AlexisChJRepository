package com.example.hwk3alexischj;

import java.io.Serializable;
import java.util.ArrayList;

public class Topic implements Serializable {
    private String title;
    private String description;
    private ArrayList<Flashcard> flashcards;

    public Topic() {
        this("", "");
    }

    public Topic(String title, String description) {
        this.title = title;
        this.description = description;
        this.flashcards = new ArrayList<>();
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public ArrayList<Flashcard> getFlashcards() {
        if (flashcards == null) flashcards = new ArrayList<>();
        return flashcards;
    }

    public void setFlashcards(ArrayList<Flashcard> list) {
        this.flashcards = (list == null) ? new ArrayList<>() : list;
    }

    public void addFlashcard(Flashcard f) {
        getFlashcards().add(f);
    }
}
