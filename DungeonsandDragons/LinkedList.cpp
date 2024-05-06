#include "LinkedList.h"
#include "Monster.h"
#include "Calabozo.h"

#include <iostream>
using namespace std;
template <typename T> LinkedList<T>::LinkedList() { first = nullptr; }
template <typename T> void LinkedList<T>::addNode(Node<T> *node) {
  if (first == nullptr) {
    first = node;
  } else {
    Node<T> *temp = first;
    while (temp->getNext() != nullptr) {
      temp = temp->getNext();
    }
    temp->setNext(node);
  }
}

template <typename T> void LinkedList<T>::addToEnd(T value) {
  Node<T> *node = new Node<T>(value);
  addNode(node);
}

template <typename T> void LinkedList<T>::print() {
  Node<T> *temp = first;
  while (temp != nullptr) {
    cout << endl << temp->getData() << ",";
    temp = temp->getNext();
  }
  cout << endl;
}
template <typename T> int LinkedList<T>::find(T data) {
  Node<T> *temp = first;
  int count = 0;
  while (temp != nullptr) {
    if (temp->getData() == data) {
      break;
    }
    count++;
    temp = temp->getNext();
  }
  if (temp == nullptr) {
    return -1;
  }
  return count;
}

template <typename T> void LinkedList<T>::swap(int x, int y) {
  T temp = findAtPos(x)->getData();
  findAtPos(x)->setData(findAtPos(y)->getData());
  findAtPos(y)->setData(temp);
}
template <typename T> Node<T> *LinkedList<T>::findAtPos(int pos) {
  Node<T> *temp = first;
  int count = 0;
  while (temp != nullptr) {
    if (count == pos) {
      return temp;
    }
    count++;
    temp = temp->getNext();
  }
  return nullptr;
}
template <typename T> void LinkedList<T>::bubbleSort() {
  Node<T> *temp1 = first;
  while (temp1 != nullptr) {
    Node<T> *temp2 = first;
    int j = 0;
    while (temp2->getNext() != nullptr) {
      if (temp2->getData() > temp2->getNext()->getData()) {
        swap(j, j + 1);
      }
      j++;
      temp2 = temp2->getNext();
    }
    temp1 = temp1->getNext();
  }
}

template <typename T> T LinkedList<T>::popFirstNode() {
  if (first == nullptr) {
    return T();
  }
  Node<T>* temp = first->getNext();
  T data = first->getData();
  delete first;
  first = temp;
  return data;
}

template <typename T> int LinkedList<T>::size() {
  if (first == nullptr) {
    return 0;
  }
  int amount = 0;
  Node<T>* iter = first;
  while (iter != nullptr) {
    amount++;
    iter = iter->getNext();
  }
  return amount;
}

template class LinkedList<Monster>;
template class LinkedList<Calabozo>;
