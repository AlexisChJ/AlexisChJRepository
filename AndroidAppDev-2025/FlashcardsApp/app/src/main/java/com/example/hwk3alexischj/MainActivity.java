package com.example.hwk3alexischj;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.view.GravityCompat;           // <-- add
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.navigation.NavigationView;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {

    private RecyclerView topicRV;
    private TopicAdapter adapter;
    private ArrayList<Topic> topicArrayList;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        topicRV = findViewById(R.id.idRVTopic);
        loadData();
        buildRecyclerView();

        View myButton = findViewById(R.id.addTopic);
        myButton.setOnClickListener(this::onButtonShowPopupWindowClick);
    }

    private void buildRecyclerView() {
        adapter = new TopicAdapter(topicArrayList, MainActivity.this);
        topicRV.setHasFixedSize(true);
        topicRV.setLayoutManager(new LinearLayoutManager(this));
        topicRV.setAdapter(adapter);
    }

    private void loadData() {
        SharedPreferences sp = getSharedPreferences("shared preferences", MODE_PRIVATE);
        Gson gson = new Gson();
        String json = sp.getString("topics", null);
        Type type = new TypeToken<ArrayList<Topic>>(){}.getType();
        topicArrayList = gson.fromJson(json, type);
        if (topicArrayList == null) topicArrayList = new ArrayList<>();
    }

    private void saveData() {
        SharedPreferences sp = getSharedPreferences("shared preferences", MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        String json = new Gson().toJson(topicArrayList);
        editor.putString("topics", json);
        editor.apply();
        Toast.makeText(this, "Saved Array List to Shared preferences.", Toast.LENGTH_SHORT).show();
    }

    public void onButtonShowPopupWindowClick(View anchor) {
        LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
        View popupView = inflater.inflate(R.layout.popup, null);

        EditText titleET = popupView.findViewById(R.id.popuptitle);
        EditText descET  = popupView.findViewById(R.id.popupdescription);
        Button addPopupBtn = popupView.findViewById(R.id.addTopicPOPUP);

        int width = LinearLayout.LayoutParams.MATCH_PARENT;
        int height = LinearLayout.LayoutParams.WRAP_CONTENT;
        boolean focusable = true;

        final PopupWindow popupWindow = new PopupWindow(popupView, width, height, focusable);

        popupWindow.setBackgroundDrawable(getDrawable(android.R.color.transparent));
        popupWindow.setOutsideTouchable(true);
        popupWindow.setFocusable(true);

        popupWindow.showAtLocation(anchor, Gravity.CENTER, 0, 0);

        addPopupBtn.setOnClickListener(v -> {
            String title = titleET.getText().toString().trim();
            String desc  = descET.getText().toString().trim();

            topicArrayList.add(new Topic(title, desc));
            adapter.notifyItemInserted(topicArrayList.size() - 1);

            saveData();

            Toast.makeText(MainActivity.this, "Topic added", Toast.LENGTH_SHORT).show();
            popupWindow.dismiss();
        });
    }
}
