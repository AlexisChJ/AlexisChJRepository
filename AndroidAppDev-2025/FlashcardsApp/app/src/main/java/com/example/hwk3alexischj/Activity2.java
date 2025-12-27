package com.example.hwk3alexischj;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;

public class Activity2 extends AppCompatActivity {

    private ArrayList<Topic> topics;
    private Topic topic;
    private int topicIndex = -1;
    private FlashcardAdapter adapter;
    private RecyclerView flashcardRV;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_2);

        TextView receiver = findViewById(R.id.receiver);
        FloatingActionButton fab = findViewById(R.id.fabAddFlashcard);
        flashcardRV = findViewById(R.id.flashcardRV);

        topicIndex = getIntent().getIntExtra("topic_index", -1);
        topics = loadTopics();

        topic = topics.get(topicIndex);
        if (topic.getFlashcards() == null) topic.setFlashcards(new ArrayList<>());

        receiver.setText(topic.getTitle());

        adapter = new FlashcardAdapter(topic.getFlashcards());
        flashcardRV.setLayoutManager(new LinearLayoutManager(this));
        flashcardRV.setHasFixedSize(true);
        flashcardRV.setAdapter(adapter);

        fab.setOnClickListener(this::onFlashcardPopupClick);
    }

    public void onFlashcardPopupClick(View anchor) {
        LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
        View popupView = inflater.inflate(R.layout.popup_flashcard, null);

        EditText conceptET = popupView.findViewById(R.id.etConcept);
        EditText answerET  = popupView.findViewById(R.id.etAnswer);
        Button addPopupBtn = popupView.findViewById(R.id.btnAddFlashcard);

        int width = LinearLayout.LayoutParams.MATCH_PARENT;
        int height = LinearLayout.LayoutParams.WRAP_CONTENT;
        boolean focusable = true;

        final PopupWindow popupWindow = new PopupWindow(popupView, width, height, focusable);

        popupWindow.setBackgroundDrawable(getDrawable(android.R.color.transparent));
        popupWindow.setOutsideTouchable(true);
        popupWindow.setFocusable(true);

        popupWindow.showAtLocation(anchor, Gravity.CENTER, 0, 0);

        addPopupBtn.setOnClickListener(v -> {
            String c = conceptET.getText().toString().trim();
            String a = answerET.getText().toString().trim();

            Flashcard f = new Flashcard(c, a);
            topic.addFlashcard(f);

            adapter.notifyItemInserted(topic.getFlashcards().size() - 1);
            topics.set(topicIndex, topic);
            saveTopics(topics);

            Toast.makeText(Activity2.this, "Flashcard added", Toast.LENGTH_SHORT).show();
            popupWindow.dismiss();
        });
    }

    private ArrayList<Topic> loadTopics() {
        SharedPreferences sp = getSharedPreferences("shared preferences", MODE_PRIVATE);
        String json = sp.getString("topics", null);
        if (json == null) return null;
        Type type = new TypeToken<ArrayList<Topic>>(){}.getType();
        return new Gson().fromJson(json, type);
    }

    private void saveTopics(ArrayList<Topic> list) {
        SharedPreferences sp = getSharedPreferences("shared preferences", MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString("topics", new Gson().toJson(list));
        editor.apply();
    }
}
