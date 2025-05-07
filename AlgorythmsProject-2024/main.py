# Alexis Chávez Juárez A01657486
# Rodrigo Fernando Rivera Olea A01664716
# Manuel Antonio Morales González A01664652

# FUNCION UNO PARA LA PARTE UNO - Algoritmo de Prim
from typing import List, Tuple

def prim(n: int, distancias: List[List[int]], capacidad: List[List[int]]) -> str:
    """Algoritmo de Prim para encontrar la mejor manera de cablear con fibra óptica las colonias,
    construyendo un Minimum Spanning Tree (MST) basado en distancias mínimas.
    
    Args:
        n: número de nodos (colonias)
        distancias: matriz de adyacencia con las distancias (pesos)
        capacidad: matriz de capacidades de flujo máximo entre colonias

    Returns:
        str: Formateado como las conexiones del MST
    """
    seleccionado: List[bool] = [False] * n  
    min_valores: List[int] = [int(1e9)] * n  # Inicializar con un número grande en lugar de infinito
    padre: List[int] = [-1] * n  
    min_valores[0] = 0  

    for _ in range(n):
        u: int = -1
        for i in range(n):
            if not seleccionado[i] and (u == -1 or min_valores[i] < min_valores[u]):
                u = i
        seleccionado[u] = True
        for v in range(n):
            if distancias[u][v] != 0 and not seleccionado[v] and distancias[u][v] < min_valores[v]:
                min_valores[v] = distancias[u][v]
                padre[v] = u

    conexiones: List[Tuple[int, int]] = []
    for i in range(1, n):
        conexiones.append((padre[i], i))  

    # Formatear la salida
    conexiones_str = ", ".join([f"({con[0]}, {con[1]})" for con in conexiones])
    return conexiones_str

# FUNCION DOS PARA LA PARTE DOS - Algoritmo del Viajero (TSP)
def tsp(n: int, distancias: List[List[int]]) -> str:
    """Algoritmo de Fuerza Bruta para resolver el Problema del Viajero (TSP), encontrando 
    la ruta más corta posible que visita cada colonia exactamente una vez y regresa al origen.

    Args:
        n: número de nodos (colonias)
        distancias: matriz de adyacencia con las distancias (pesos)

    Returns:
        str: Formateado como la ruta más corta
    """
    
    def calcular_costo(ruta: List[int]) -> int:
        """Calcula el costo total de una ruta

        Args:
            ruta: Secuencia de nodos en la ruta

        Returns:
            Costo total de la ruta
        """
        costo: int = 0
        for i in range(n - 1):
            costo += distancias[ruta[i]][ruta[i + 1]]
        costo += distancias[ruta[-1]][ruta[0]]  # Volvemos al punto de inicio
        return costo

    def permutaciones(ruta_actual: List[int], nodos_restantes: List[int]) -> List[List[int]]:
        """Genera todas las permutaciones posibles de rutas

        Args:
            ruta_actual: Ruta actual en construcción
            nodos_restantes: Nodos restantes por visitar

        Returns:
            Lista de todas las rutas posibles
        """
        if not nodos_restantes:
            return [ruta_actual]

        rutas: List[List[int]] = []
        for i in range(len(nodos_restantes)):
            siguiente_nodo: int = nodos_restantes[i]
            nuevas_rutas: List[List[int]] = permutaciones(ruta_actual + [siguiente_nodo], nodos_restantes[:i] + nodos_restantes[i + 1:])
            rutas.extend(nuevas_rutas)
        return rutas

    # Generar todas las posibles rutas comenzando desde el nodo 0
    nodos: List[int] = list(range(1, n)) 
    rutas: List[List[int]] = permutaciones([0], nodos)
    mejor_ruta: List[int] = []
    menor_costo: int = int(1e9)  # Usar un número grande en lugar de infinito

    # Encontrar la ruta óptima
    for ruta in rutas:
        costo: int = calcular_costo(ruta)
        if costo < menor_costo:
            menor_costo = costo
            mejor_ruta = ruta

    conexiones: List[Tuple[int, int]] = []
    for i in range(len(mejor_ruta)):
        u: int = mejor_ruta[i]
        v: int = mejor_ruta[(i + 1) % n] 
        conexiones.append((u, v))

    # Formatear la salida
    conexiones_str = ", ".join([f"({u}, {v})" for u, v in conexiones])
    return conexiones_str

# FUNCION TRES PARA LA PARTE TRES - Algoritmo de Flujo Máximo (Edmonds-Karp)
def bfs(capacidad: List[List[int]], flujo: List[List[int]], fuente: int, lleno: int, padre: List[int]) -> bool:
    """Busca un camino aumentante en el grafo de flujo

    Args:
        capacidad: Matriz de capacidades de flujo
        flujo: Matriz de flujo actual
        fuente: Nodo origen
        lleno: Nodo destino
        padre: Lista de padres para reconstruir el camino

    Returns:
        Verdadero si se encontró un camino aumentante
    """
    visitado: List[bool] = [False] * len(capacidad)
    queue: List[int] = [fuente]
    visitado[fuente] = True

    while queue:
        u: int = queue.pop(0)

        for v in range(len(capacidad)):
            if not visitado[v] and capacidad[u][v] - flujo[u][v] > 0:  
                queue.append(v)
                visitado[v] = True
                padre[v] = u
                if v == lleno:
                    return True
    return False

def max_flujo(n: int, capacidad: List[List[int]], fuente: int, lleno: int) -> str:
    """Calcula el flujo máximo entre dos nodos usando el algoritmo Edmonds-Karp

    Args:
        n: Número de nodos
        capacidad: Matriz de capacidades de flujo
        fuente: Nodo origen
        lleno: Nodo destino

    Returns:
        str: Formateado como el flujo máximo
    """
    flujo: List[List[int]] = [[0] * n for _ in range(n)]  
    padre: List[int] = [-1] * n  
    max_valor_flujo: int = 0

    while bfs(capacidad, flujo, fuente, lleno, padre):
        flujo_camino: int = int(1e9)  # Usar un número grande en lugar de infinito
        v: int = lleno

        while v != fuente:
            u: int = padre[v]
            flujo_camino = min(flujo_camino, capacidad[u][v] - flujo[u][v])
            v = padre[v]

        v = lleno
        while v != fuente:
            u = padre[v]
            flujo[u][v] += flujo_camino
            flujo[v][u] -= flujo_camino
            v = padre[v]

        max_valor_flujo += flujo_camino

    return str(max_valor_flujo)

def main() -> None:
    """Función principal que lee los datos de entrada y ejecuta los algoritmos correspondientes."""
    with open("input.txt", "r") as file:
        n: int = int(file.readline().strip())
        
        distancias: List[List[int]] = []
        for _ in range(n):
            row: List[int] = list(map(int, file.readline().strip().split()))
            distancias.append(row)
        
        capacidad: List[List[int]] = []
        for _ in range(n):
            row: List[int] = list(map(int, file.readline().strip().split()))
            capacidad.append(row)

    # Función Parte 1 - Prim
    prim(n, distancias, capacidad)

    # Función Parte 2 - TSP
    tsp(n, distancias)

    # Función Parte 3 - Flujo máximo
    max_flujo(n, capacidad, 0, n - 1)

if __name__ == "__main__":
    main()
