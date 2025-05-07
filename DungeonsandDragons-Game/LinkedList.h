#ifndef LINKED_LIST_H
#define LINKED_LIST_H
#include "Node.h"

template <typename T> class LinkedList {
private:
  Node<T> *first;

public:
  LinkedList();
  void addNode(Node<T> *node);
  void addToEnd(T value);
  T popFirstNode();
  void print();
  int find(T data);
  int size();
  void swap(int x, int y);
  Node<T> *findAtPos(int pos);
  void bubbleSort();
};
#endif
