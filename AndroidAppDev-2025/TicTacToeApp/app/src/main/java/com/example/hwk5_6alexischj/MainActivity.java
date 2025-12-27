package com.example.hwk5_6alexischj;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.content.SharedPreferences;
import android.view.LayoutInflater;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    // variable declaration
    private Game game;
    private final Button[][] buttons = new Button[3][3];
    private TextView textView;
    private Button btnReset;
    private Button btnPlyName;
    private Drawable originalBackground;
    private String playerXName = "Player X";
    private String playerOName = "Player O";
    private TextView tvStatsX;
    private TextView tvStatsO;
    private TextView tvStatsTotal;
    private int xWins = 0;
    private int oWins = 0;
    private int totalGames = 0;
    private SharedPreferences prefs;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // stats
        tvStatsX = findViewById(R.id.tvStatsX);
        tvStatsO = findViewById(R.id.tvStatsO);
        tvStatsTotal = findViewById(R.id.tvStatsTotal);

        // shared preferences stuff
        prefs = getSharedPreferences("TicTacToeStats", MODE_PRIVATE);
        xWins = prefs.getInt("xWins", 0);
        oWins = prefs.getInt("oWins", 0);
        totalGames = prefs.getInt("totalGames", 0);
        update();

        game = new Game();
        textView = findViewById(R.id.textView);
        btnReset = findViewById(R.id.btnNewGame);
        btnPlyName = findViewById(R.id.btnPlyName);

        // buttons of the xml to the main activity
        buttons[0][0] = findViewById(R.id.btn00);
        buttons[0][1] = findViewById(R.id.btn01);
        buttons[0][2] = findViewById(R.id.btn02);
        buttons[1][0] = findViewById(R.id.btn10);
        buttons[1][1] = findViewById(R.id.btn11);
        buttons[1][2] = findViewById(R.id.btn12);
        buttons[2][0] = findViewById(R.id.btn20);
        buttons[2][1] = findViewById(R.id.btn21);
        buttons[2][2] = findViewById(R.id.btn22);

        // this helps to reset the orginal maze
        originalBackground = buttons[0][0].getBackground();
        textView.setText(playerXName + "’s turn");

        // click listeners of the 9 buttons
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                final int x = i;
                final int y = j;
                buttons[i][j].setOnClickListener(v -> onCellPressed(x, y));
            }
        }

        // buttons to set players names and resetting the game
        btnPlyName.setOnClickListener(v -> showPopUp());
        btnReset.setOnClickListener(v -> {
            game.resetGame();
            resetBoard();
            textView.setText(playerXName);
        });
    }

    // logic of the game itself when the buttons are clicked
    private void onCellPressed(int x, int y) {
        boolean success = game.makeMove(x, y);
        if (!success) return;

        Object cell = game.getMaze().getMatrix()[x][y];
        if (cell instanceof Cross)
            buttons[x][y].setBackgroundResource(R.drawable.cross);
        else if (cell instanceof Circle)
            buttons[x][y].setBackgroundResource(R.drawable.circle);

        // methods calls when winning x, o or draw
        int winner = game.checkWinner();
        if (winner == 1) {
            textView.setText(playerXName + " wins!");
            animationWinner();
            disableBoard();
            xWins++;
            totalGames++;
            save();
        } else if (winner == 2) {
            textView.setText(playerOName + " wins!");
            animationWinner();
            disableBoard();
            oWins++;
            totalGames++;
            save();
        } else if (isFull()) {
            textView.setText("It's a draw!");
            totalGames++;
            save();
        }

    }

    // animation for winning O or X
    private void animationWinner() {
        Animation blinkAnim = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.blink);
        int[][] winPos = game.getWinningPositions();

        for (int[] pos : winPos) {
            int x = pos[0];
            int y = pos[1];
            buttons[x][y].startAnimation(blinkAnim);
        }
    }


    // draqw option
    private boolean isFull() {
        Object[][] m = game.getMaze().getMatrix();
        for (Object[] row : m) {
            for (Object cell : row) {
                if (cell == null){
                    return false;
                }
            }
        }
        return true;
    }

    // let user not to touch the maze, it means that someone has won or is a draw
    private void disableBoard() {
        for (Button[] row : buttons) {
            for (Button b : row) {
                b.setEnabled(false);
            }
        }
    }

    // resetting board to the orginal color button and that enambles touch of the user
    private void resetBoard() {
        for (Button[] row : buttons) {
            for (Button b : row) {
                b.clearAnimation();
                b.setBackground(originalBackground);
                b.setEnabled(true);
            }
        }

    }

    // pop up of the names players
    private void showPopUp() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Enter Player Names");

        // inflating the view
        LayoutInflater inflater = getLayoutInflater();
        final android.view.View dialogView = inflater.inflate(R.layout.popup_players, null);
        builder.setView(dialogView);

        EditText etPlayerX = dialogView.findViewById(R.id.etPlayerX);
        EditText etPlayerO = dialogView.findViewById(R.id.etPlayerO);

        etPlayerX.setText(playerXName);
        etPlayerO.setText(playerOName);

        builder.setPositiveButton("Save", (dialog, which) -> {
            playerXName = etPlayerX.getText().toString().trim();
            playerOName = etPlayerO.getText().toString().trim();

            if (playerXName.isEmpty()) {
                playerXName = "Player X";
            }
            if (playerOName.isEmpty()) {
                playerOName = "Player O";
            }
        });

        builder.setNegativeButton("Cancel", (dialog, which) -> dialog.dismiss());
        builder.create().show();
    }

    // saving the data using shared preferences
    private void save() {
        SharedPreferences.Editor editor = prefs.edit();
        editor.putInt("xWins", xWins);
        editor.putInt("oWins", oWins);
        editor.putInt("totalGames", totalGames);
        editor.apply();
        update();
    }

    // setting the data of wins of each player and the total game
    private void update() {
        tvStatsX.setText("X Wins: " + xWins);
        tvStatsO.setText("O Wins: " + oWins);
        tvStatsTotal.setText("Total Games: " + totalGames);
    }

}
