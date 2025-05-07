# Alexis Chávez Juárez A01657486
# Rodrigo Fernando Rivera Olea A01664716
# Manuel Antonio Morales González A01664652

import unittest
from typing import List
from main import prim, tsp, max_flujo

class TestMain(unittest.TestCase):
    def setUp(self) -> None:
        """Configura datos comunes para las pruebas."""
        self.n: int = 4
        self.distancias: List[List[int]] = [
            [0, 16, 45, 32],
            [16, 0, 18, 21],
            [45, 18, 0, 7],
            [32, 21, 7, 0]
        ]
        self.capacidad: List[List[int]] = [
            [0, 48, 12, 18],
            [52, 0, 42, 32],
            [18, 46, 0, 56],
            [24, 36, 52, 0]
        ]

    def test_prim(self) -> None:
        """Prueba general del algoritmo de Prim."""
        resultado: str = prim(self.n, self.distancias, self.capacidad)
        self.assertIsInstance(resultado, str)
        self.assertTrue(resultado.startswith("("))
        self.assertIn(",", resultado)

    def test_tsp(self) -> None:
        """Prueba general del algoritmo TSP."""
        resultado: str = tsp(self.n, self.distancias)
        self.assertIsInstance(resultado, str)
        self.assertTrue(resultado.startswith("("))
        self.assertIn(",", resultado)

    def test_max_flujo(self) -> None:
        """Prueba general del algoritmo de flujo máximo."""
        resultado: str = max_flujo(self.n, self.capacidad, 0, self.n - 1)
        self.assertIsInstance(resultado, str)
        self.assertTrue(resultado.isdigit())
        self.assertGreaterEqual(int(resultado), 0)

    def test_prim_specific_case(self) -> None:
        """Prueba específica del algoritmo de Prim."""
        distancias: List[List[int]] = [
            [0, 2, 0, 6, 0],
            [2, 0, 3, 8, 5],
            [0, 3, 0, 0, 7],
            [6, 8, 0, 0, 9],
            [0, 5, 7, 9, 0]
        ]
        capacidad: List[List[int]] = [
            [0, 2, 0, 6, 0],
            [2, 0, 3, 8, 5],
            [0, 3, 0, 0, 7],
            [6, 8, 0, 0, 9],
            [0, 5, 7, 9, 0]
        ]
        resultado: str = prim(5, distancias, capacidad)
        self.assertEqual(resultado, "(0, 1), (1, 2), (0, 3), (1, 4)")

    def test_tsp_specific_case(self) -> None:
        """Prueba específica del algoritmo TSP."""
        distancias: List[List[int]] = [
            [0, 10, 15, 20],
            [10, 0, 35, 25],
            [15, 35, 0, 30],
            [20, 25, 30, 0]
        ]
        resultado: str = tsp(4, distancias)
        self.assertIsInstance(resultado, str)
        self.assertTrue(resultado.startswith("("))

    def test_max_flujo_specific_case(self) -> None:
        """Prueba específica del algoritmo de flujo máximo."""
        capacidad: List[List[int]] = [
            [0, 16, 13, 0, 0, 0],
            [0, 0, 10, 12, 0, 0],
            [0, 4, 0, 0, 14, 0],
            [0, 0, 9, 0, 0, 20],
            [0, 0, 0, 7, 0, 4],
            [0, 0, 0, 0, 0, 0]
        ]
        resultado: str = max_flujo(6, capacidad, 0, 5)
        self.assertEqual(resultado, "23")

if __name__ == "__main__":
    unittest.main()
