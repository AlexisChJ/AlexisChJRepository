package com.example.hwk5_6alexischj;

public class Maze {
    private final Object[][] matrix;

    public Maze() {
        matrix = new Object[3][3]; // null = empty
    }

    public Object[][] getMatrix() {
        return matrix;
    }

    public void resetMatrix() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                matrix[i][j] = null;
            }
        }
    }

    public void putCross(int x, int y) {
        if (isValid(x, y) && matrix[x][y] == null) {
            matrix[x][y] = new Cross();
        }
    }

    public void putCircle(int x, int y) {
        if (isValid(x, y) && matrix[x][y] == null) {
            matrix[x][y] = new Circle();
        }
    }

    private boolean isValid(int x, int y) {
        return x >= 0 && x < 3 && y >= 0 && y < 3;
    }
}
