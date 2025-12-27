package com.example.hwk5_6alexischj;

public class Game {
    private final Maze maze;
    private final Player player1;
    private final Player player2;
    private Player currentPlayer;
    private boolean gameOver;
    private int[][] winningPositions = null;

    public Game() {
        maze = new Maze();
        player1 = new Player();
        player2 = new Player();

        player1.setCross();
        player2.setCircle();

        currentPlayer = player1;
        gameOver = false;
    }

    public Maze getMaze() {
        return maze;
    }

    public Player getCurrentPlayer() {
        return currentPlayer;
    }

    public void resetGame() {
        maze.resetMatrix();
        currentPlayer = player1;
        gameOver = false;
    }

    public boolean makeMove(int x, int y) {
        if (gameOver) {
            return false;
        }

        Object[][] m = maze.getMatrix();
        if (m[x][y] != null) {
            return false; // already filled
        }

        if (currentPlayer == player1) maze.putCross(x, y);
        else maze.putCircle(x, y);

        int winner = checkWinner();
        if (winner != 0 || isFull()) {
            gameOver = true;
            return true;
        }

        switchTurn();
        return true;
    }

    private void switchTurn() {
        currentPlayer = (currentPlayer == player1) ? player2 : player1;
    }

    private boolean isFull() {
        Object[][] m = maze.getMatrix();
        for (Object[] row : m) {
            for (Object cell : row) if (cell == null) {
                return false;
            }
        }
        return true;
    }

    public int checkWinner() {
        Object[][] m = maze.getMatrix();

        // check rows
        for (int i = 0; i < 3; i++) {
            if (same(m[i][0], m[i][1], m[i][2])) {
                winningPositions = new int[][]{{i, 0}, {i, 1}, {i, 2}};
                return getValue(m[i][0]);
            }
        }

        // check columns
        for (int j = 0; j < 3; j++) {
            if (same(m[0][j], m[1][j], m[2][j])) {
                winningPositions = new int[][]{{0, j}, {1, j}, {2, j}};
                return getValue(m[0][j]);
            }
        }

        // check main diagonal
        if (same(m[0][0], m[1][1], m[2][2])) {
            winningPositions = new int[][]{{0, 0}, {1, 1}, {2, 2}};
            return getValue(m[0][0]);
        }

        // check anti-diagonal
        if (same(m[0][2], m[1][1], m[2][0])) {
            winningPositions = new int[][]{{0, 2}, {1, 1}, {2, 0}};
            return getValue(m[0][2]);
        }

        // no winner
        winningPositions = null;
        return 0;
    }


    private boolean same(Object a, Object b, Object c) {
        if (a == null || b == null || c == null) {
            return false;
        }
        return a.getClass() == b.getClass() && b.getClass() == c.getClass();
    }


    private int getValue(Object o) {
        if (o instanceof Cross) {
            return 1;
        }
        if (o instanceof Circle) {
            return 2;
        }
        return 0;
    }

    public int[][] getWinningPositions() {
        return winningPositions;
    }
}
